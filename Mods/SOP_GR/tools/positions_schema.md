# Positions TSV Schema

This describes the tab-separated table used by `tools/compile_positions.py`.

## Location
- Source table: `Mods/SOP_GR/data/positions.tsv`
- Compiler: `Mods/SOP_GR/tools/compile_positions.py`

## Conventions
- Use `|` to separate multiple values inside a single cell.
- Boolean fields accept `1`, `true`, `yes`, or `y` (case-insensitive).
- Empty cells are ignored.
- `extra_tags` accepts raw tags; if a tag does not start with `[`, the compiler will wrap it.

## Columns
- `id`: Position ID (required)
- `comment`: Optional single-line comment emitted above the position
- `name`, `name_male`, `name_female`
- `spouse_male`, `spouse_female`, `spouse`
- `description`, `land_name`
- `site`: boolean -> `[SITE]`
- `precedence`, `number`
- `elected`: boolean -> `[ELECTED]`
- `appointed_by`: `|`-list -> `[APPOINTED_BY:...]`
- `succession_by_position`: `|`-list -> `[SUCCESSION:BY_POSITION:...]`
- `succession_by_heir`: boolean -> `[SUCCESSION:BY_HEIR]`
- `requires_population`
- `responsibilities`: `|`-list -> `[RESPONSIBILITY:...]`
- `menial_work_exemption`, `menial_work_exemption_spouse`, `chat_worthy`, `quest_giver`,
  `sleep_pretension`, `do_not_cull`, `exported_in_legends`, `duty_bound`, `requires_market`
- `demand_max`, `required_bedroom`, `required_dining`, `required_office`, `required_tomb`,
  `required_cabinets`, `required_boxes`, `required_racks`, `required_stands`, `color`
- `extra_tags`: `|`-list of raw tags (e.g., `RULES_FROM_LOCATION` or `COMMANDER:MG_CAPTAIN:ALL`)

## Example
```
id	comment	name	number	site	requires_population	appointed_by	succession_by_position
MAYOR_1	starter mayor	Mayor:Mayors	1	true	60	LH1	CITIZEN_2|CITIZEN_3
```
