void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Normalized pixel coordinates (from -1 to 1) with 0,0 in the centre
    vec2 uv = fragCoord / iResolution.xy * 2.0 - 1.0;
    // Take the aspect ratio of the canvas into account
    uv.x *= iResolution.x / iResolution.y;

    float d = length(uv);
    d = sin(d * 8. + iTime) / 8.;
    d = abs(d);
    d = smoothstep(0.0, 0.1, d);

    // Output to screen
    fragColor = vec4(d, d, d, 1.0);

}