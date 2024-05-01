shader_type canvas_item;

void fragment() {
	vec4 curr_texture = vec4(0.3, 0.3, 1.0, 1.0);
	vec4 offset = vec4(0.4, 0.1, 0.3, 0.0);
	vec4 border = vec4(0.0, 0.0, 0.0, 1.0);
	vec4 new_color = vec4(0.0, 0.0, 0.0, 0.0);
	
	if(UV.x < 0.04 || UV.x > 0.96 ||
	   UV.y < 0.04 || UV.y > 0.96)
	{
		new_color = border;
	}
	else
	{
		new_color = curr_texture + offset * cos(TIME) * 0.4;
	}
	COLOR = new_color;
}
