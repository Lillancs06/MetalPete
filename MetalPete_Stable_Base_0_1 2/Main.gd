extends Node2D

const FLOOR_Y := 445.0
const WORLD_W := 2100.0

var player := Vector2(140.0, FLOOR_Y)
var velocity := Vector2.ZERO
var facing := 1.0
var camera_x := 0.0
var on_floor := true
var message := "STABLE BASE — MOVE, JUMP, PUNCH"
var message_time := 4.0

func _ready() -> void:
    queue_redraw()

func _process(delta: float) -> void:
    var left := Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT)
    var right := Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT)
    var run := Input.is_key_pressed(KEY_SHIFT)
    var speed := 300.0 if run else 210.0
    var axis := float(int(right) - int(left))

    velocity.x = move_toward(velocity.x, axis * speed, 1500.0 * delta)
    if abs(axis) < 0.01:
        velocity.x = move_toward(velocity.x, 0.0, 1700.0 * delta)
    elif axis != 0.0:
        facing = sign(axis)

    if (Input.is_key_pressed(KEY_SPACE) or Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP)) and on_floor:
        velocity.y = -490.0
        on_floor = false
        show_message("HUFF!")

    if not on_floor:
        velocity.y += 1400.0 * delta

    player += velocity * delta
    player.x = clamp(player.x, 30.0, WORLD_W - 30.0)

    if player.y >= FLOOR_Y:
        player.y = FLOOR_Y
        velocity.y = 0.0
        on_floor = true

    camera_x = clamp(player.x - 320.0, 0.0, WORLD_W - 960.0)

    if message_time > 0.0:
        message_time -= delta

    queue_redraw()

func _input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed and not event.echo:
        if event.keycode == KEY_X:
            show_message("PUNCH!")
        elif event.keycode == KEY_C:
            show_message("KICK!")
        elif event.keycode == KEY_F:
            show_message("BOTTLE!")
        elif event.keycode == KEY_E:
            show_message("GOT BEER? ... THEN DON'T DIE.")

func show_message(text: String) -> void:
    message = text
    message_time = 1.3

func _draw() -> void:
    draw_rect(Rect2(0, 0, 960, 540), Color("#090b12"))

    var ox := -camera_x

    for i in range(18):
        var x := ox + i * 130.0
        var h := 90.0 + float((i % 5) * 24)
        draw_rect(Rect2(x, FLOOR_Y - h - 70.0, 92.0, h), Color("#151a28"))

    draw_string(ThemeDB.fallback_font, Vector2(ox + 310.0, 120.0),
        "THE LAST ROUND", HORIZONTAL_ALIGNMENT_LEFT, -1, 34, Color("#ff3c9f"))

    draw_rect(Rect2(0, FLOOR_Y, 960, 95), Color("#18131a"))

    for i in range(20):
        draw_rect(Rect2(ox + i * 110.0, FLOOR_Y + 22.0 + float((i % 3) * 10), 60.0, 4.0),
            Color(0.75, 0.18, 0.55, 0.22))

    draw_pete(Vector2(ox + player.x, player.y), facing)

    draw_rect(Rect2(12, 12, 936, 42), Color(0.0, 0.0, 0.0, 0.72))
    draw_string(ThemeDB.fallback_font, Vector2(25, 41),
        "A/D: MOVE   SPACE: JUMP   X: PUNCH   C: KICK   F: BOTTLE   E: INTERACT",
        HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color("#f2ead8"))

    if message_time > 0.0:
        draw_rect(Rect2(250, 74, 460, 44), Color(0.0, 0.0, 0.0, 0.76))
        draw_string(ThemeDB.fallback_font, Vector2(270, 104), message,
            HORIZONTAL_ALIGNMENT_CENTER, 420, 22, Color("#ffd77a"))

func draw_pete(pos: Vector2, dir: float) -> void:
    draw_line(pos + Vector2(-14.0 * dir, -78.0), pos + Vector2(-27.0 * dir, -34.0),
        Color("#24150f"), 12.0)
    draw_line(pos + Vector2(-11.0, -12.0), pos + Vector2(-12.0, 25.0),
        Color("#b88461"), 10.0)
    draw_line(pos + Vector2(11.0, -12.0), pos + Vector2(13.0, 25.0),
        Color("#b88461"), 10.0)
    draw_rect(Rect2(pos.x - 22.0, pos.y - 44.0, 44.0, 31.0), Color("#46512a"))
    draw_rect(Rect2(pos.x - 25.0, pos.y - 80.0, 50.0, 39.0), Color("#101015"))
    draw_circle(pos + Vector2(0.0, -94.0), 17.0, Color("#b88461"))
    draw_colored_polygon(PackedVector2Array([
        pos + Vector2(-18.0, -94.0),
        pos + Vector2(18.0, -94.0),
        pos + Vector2(12.0, -67.0),
        pos + Vector2(-12.0, -67.0)
    ]), Color("#3a2419"))
    draw_circle(pos + Vector2(7.0 * dir, -99.0), 2.5, Color("#48d46a"))
    draw_line(pos + Vector2(13.0 * dir, -90.0), pos + Vector2(29.0 * dir, -85.0),
        Color("#6b3b18"), 4.0)
