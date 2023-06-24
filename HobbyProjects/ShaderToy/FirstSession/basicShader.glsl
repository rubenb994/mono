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

    // Keep track of original distance towards center of canvas.
    vec2 uv0 = uv;

    // Final output color.
    vec3 finalColor = vec3(0.0);

    // Fractal depth
    float fractalDepth = 4.0;

    for(float i = 0.0; i < fractalDepth; i++) {
        // Make the shape a fractal & apply in the clipspace.
        // Making the fractalOffSet a decimal number makes the fractal more intreseting to look at.
        uv = fract(uv * 1.5) - 0.5;

        float d = length(uv) * exp(-length(uv0));

        // Offset gradiant over time.
        float timeOffSet = 0.4;
        // Include i within the palette to introduce more variation.
        vec3 col = palette(length(uv0) + i * timeOffSet + iTime * timeOffSet);

        float amountOfSineWaves = 8.0;
        // Multiply & devide by the amountOfSineWaves to compensate for the color intensity.
        d = sin(d * amountOfSineWaves + iTime) / amountOfSineWaves;
        d = abs(d);

        // Increase constrast.
        d = pow(0.01 / d, 1.2);

        finalColor += col * d;
    }

    // Output to screen
    fragColor = vec4(finalColor, 1.0);

}