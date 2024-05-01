shader_type canvas_item;

void fragment() {
	vec4 curr_texture = vec4(0.0, 0.0, 0.8, 1.0);
	vec4 offset = vec4(0.4, 0.1, 0.3, 0.0);
	vec4 border = vec4(0.0, 0.0, 0.0, 1.0);
	vec4 new_color = vec4(0.0, 0.0, 0.0, 0.0);
	float border_offset = 0.08;
	float inv_border_offset = 1.0 - border_offset;
	
	if(UV.x < border_offset || UV.x > inv_border_offset ||
	   UV.y < border_offset || UV.y > inv_border_offset)
	{
		new_color = border;
	}
	else
	{
		new_color = curr_texture + offset * cos(TIME) * 0.4;
	}
	COLOR = new_color;
}
