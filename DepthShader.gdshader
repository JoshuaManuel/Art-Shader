shader_type spatial;
render_mode unshaded;

uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float zNear : hint_range(0.0, 1.0, 0.1) = 1.0;
uniform float zFar : hint_range(1.0, 1000.0, 1) = 10.0;

void vertex() {
	CAMERA_POSITION_WORLD = VERTEX;
}

void fragment() {
	vec4 original = texture(SCREEN_TEXTURE, SCREEN_UV);
	float depth = texture(DEPTH_TEXTURE, SCREEN_UV).x; // x is distance from camera
	
	//create normalized device coordinates
	vec3 ndc = vec3(SCREEN_UV, depth) * 2.0 - 1.0;
	vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	view.xyz /= view.w;
	
	float linear_depth = view.z;
	float scaled_depth = (zFar * zNear) / (zFar + (linear_depth * (zNear - zFar)));
	
	ALBEDO = vec3(scaled_depth);
}