varying vec2 v_vTexcoord;

uniform float blur_amount;

void main()
{
    vec2 texel = vec2(blur_amount);

    vec4 col = vec4(0.0);

    col += texture2D(gm_BaseTexture, v_vTexcoord + texel * vec2(-1.0, -1.0));
    col += texture2D(gm_BaseTexture, v_vTexcoord + texel * vec2( 1.0, -1.0));
    col += texture2D(gm_BaseTexture, v_vTexcoord + texel * vec2(-1.0,  1.0));
    col += texture2D(gm_BaseTexture, v_vTexcoord + texel * vec2( 1.0,  1.0));

    col *= 0.25;

    gl_FragColor = col;
}
