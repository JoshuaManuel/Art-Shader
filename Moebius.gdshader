shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float threshold : hint_range(0, 1) = 0.1;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec4 center = texture(SCREEN_TEXTURE, uv);
    
    float dFdx_center = dFdx(center.x);
    float dFdy_center = dFdy(center.x);
    float edge = length(vec2(dFdx_center, dFdy_center)) * 0.5;
    
    float alpha = smoothstep(threshold - 0.01, threshold + 0.01, edge);
    COLOR = vec4(1.0, 1.0, 1.0, alpha);
}