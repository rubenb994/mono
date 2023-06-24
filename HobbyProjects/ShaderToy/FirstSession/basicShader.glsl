vec3 palette(float t) {
    vec3 a = vec3(0.668, 0.608, 0.310);
    vec3 b = vec3(1.032, 0.500, 0.600);
    vec3 c = vec3(0.333, 0.278, 0.278);
    vec3 d = vec3(0.660, 0.000, 0.667);
    return a + b * cos(6.28318 * (c * t + d));
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Normalized pixel coordinates (from -1 to 1) with 0,0 in the centre
    vec2 uv = fragCoord / iResolution.xy * 2.0 - 1.0;
    // Take the aspect ratio of the canvas into account
    uv.x *= iResolution.x / iResolution.y;

    vec2 uv0 = uv;
    vec3 finalColor = vec3(0.0);

    for(float i = 0.0; i < 4.0; i++) {
        uv = fract(uv * 1.5) - 0.5;

        float d = length(uv) * exp(-length(uv0));

        vec3 col = palette(length(uv0) + i * .4 + iTime * .4) * .2;

        d = sin(d * 8. + iTime) / 8.;
        d = abs(d);
        // Increase constrast
        d = pow(0.01 / d, 1.2);

        finalColor += col * d;
    }

    // Output to screen
    fragColor = vec4(finalColor, 1.0);

}