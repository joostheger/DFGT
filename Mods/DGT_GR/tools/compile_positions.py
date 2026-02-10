import argparse
import csv
from pathlib import Path

INDENT = "\t"


def parse_bool(value: str) -> bool:
    return value.strip().lower() in {"1", "true", "yes", "y"}


def split_list(value: str) -> list[str]:
    return [item.strip() for item in value.split("|") if item.strip()]


def add_tag(lines: list[str], tag: str) -> None:
    lines.append(f"{INDENT}{tag}")


def add_named_tag(lines: list[str], name: str, value: str) -> None:
    if value.strip():
        add_tag(lines, f"[{name}:{value.strip()}]")


def add_flag(lines: list[str], name: str, value: str) -> None:
    if parse_bool(value):
        add_tag(lines, f"[{name}]")


def build_position_block(row: dict[str, str]) -> list[str]:
    lines: list[str] = []

    comment = row.get("comment", "").strip()
    if comment:
        lines.append(f"{INDENT}// {comment}")

    position_id = row["id"].strip()
    lines.append(f"{INDENT}[POSITION:{position_id}]")

    add_named_tag(lines, "NAME", row.get("name", ""))
    add_named_tag(lines, "NAME_MALE", row.get("name_male", ""))
    add_named_tag(lines, "NAME_FEMALE", row.get("name_female", ""))
    add_named_tag(lines, "SPOUSE_MALE", row.get("spouse_male", ""))
    add_named_tag(lines, "SPOUSE_FEMALE", row.get("spouse_female", ""))
    add_named_tag(lines, "SPOUSE", row.get("spouse", ""))
    add_named_tag(lines, "DESCRIPTION", row.get("description", ""))
    add_named_tag(lines, "LAND_NAME", row.get("land_name", ""))

    if parse_bool(row.get("site", "")):
        add_tag(lines, "[SITE]")

    add_named_tag(lines, "PRECEDENCE", row.get("precedence", ""))
    add_named_tag(lines, "NUMBER", row.get("number", ""))

    add_flag(lines, "ELECTED", row.get("elected", ""))

    for value in split_list(row.get("appointed_by", "")):
        add_named_tag(lines, "APPOINTED_BY", value)

    for value in split_list(row.get("succession_by_position", "")):
        add_tag(lines, f"[SUCCESSION:BY_POSITION:{value}]")

    add_flag(lines, "SUCCESSION:BY_HEIR", row.get("succession_by_heir", ""))

    add_named_tag(lines, "REQUIRES_POPULATION", row.get("requires_population", ""))

    for value in split_list(row.get("responsibilities", "")):
        add_named_tag(lines, "RESPONSIBILITY", value)

    add_flag(lines, "MENIAL_WORK_EXEMPTION", row.get("menial_work_exemption", ""))
    add_flag(lines, "MENIAL_WORK_EXEMPTION_SPOUSE", row.get("menial_work_exemption_spouse", ""))
    add_flag(lines, "CHAT_WORTHY", row.get("chat_worthy", ""))
    add_flag(lines, "QUEST_GIVER", row.get("quest_giver", ""))
    add_flag(lines, "SLEEP_PRETENSION", row.get("sleep_pretension", ""))
    add_flag(lines, "DO_NOT_CULL", row.get("do_not_cull", ""))
    add_flag(lines, "EXPORTED_IN_LEGENDS", row.get("exported_in_legends", ""))
    add_flag(lines, "DUTY_BOUND", row.get("duty_bound", ""))
    add_flag(lines, "REQUIRES_MARKET", row.get("requires_market", ""))

    add_named_tag(lines, "DEMAND_MAX", row.get("demand_max", ""))
    add_named_tag(lines, "REQUIRED_BEDROOM", row.get("required_bedroom", ""))
    add_named_tag(lines, "REQUIRED_DINING", row.get("required_dining", ""))
    add_named_tag(lines, "REQUIRED_OFFICE", row.get("required_office", ""))
    add_named_tag(lines, "REQUIRED_TOMB", row.get("required_tomb", ""))
    add_named_tag(lines, "REQUIRED_CABINETS", row.get("required_cabinets", ""))
    add_named_tag(lines, "REQUIRED_BOXES", row.get("required_boxes", ""))
    add_named_tag(lines, "REQUIRED_RACKS", row.get("required_racks", ""))
    add_named_tag(lines, "REQUIRED_STANDS", row.get("required_stands", ""))
    add_named_tag(lines, "COLOR", row.get("color", ""))

    for value in split_list(row.get("extra_tags", "")):
        tag = value
        if not tag.startswith("["):
            tag = f"[{tag}]"
        add_tag(lines, tag)

    return lines


def main() -> int:
    parser = argparse.ArgumentParser(description="Compile positions TSV into sequential entity format.")
    parser.add_argument("tsv", type=Path, help="Path to positions.tsv")
    parser.add_argument("output", type=Path, help="Output file path")
    args = parser.parse_args()

    with args.tsv.open("r", encoding="utf-8", newline="") as handle:
        reader = csv.DictReader(handle, delimiter="\t")
        blocks: list[str] = []
        for row in reader:
            position_id = row.get("id", "").strip()
            if not position_id or position_id.startswith("#"):
                continue
            blocks.extend(build_position_block(row))
            blocks.append("")

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text("\n".join(blocks).rstrip() + "\n", encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
