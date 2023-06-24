float sdCircle(vec2 p, float r) {
    return length(p) - r;
}

vec3 palette(float t) {
    vec3 a = vec3(0.668, 0.608, 0.310);
    vec3 b = vec3(1.032, 0.500, 0.600);
    vec3 c = vec3(0.333, 0.278, 0.278);
    vec3 d = vec3(0.660, 0.000, 0.667);
    return a + b * cos(6.28318 * (c * t + d));
}

float sdHexagram(in vec2 p, in float r) {
    const vec4 k = vec4(-0.5, 0.8660254038, 0.5773502692, 1.7320508076);
    p = abs(p);
    p -= 2.0 * min(dot(k.xy, p), 0.0) * k.xy;
    p -= 2.0 * min(dot(k.yx, p), 0.0) * k.yx;
    p -= vec2(clamp(p.x, r * k.z, r * k.w), r);
    return length(p) * sign(p.y);
}

float dot2(in vec2 v) {
    return dot(v, v);
}

float sdHeart(in vec2 p) {
    p.x = abs(p.x);

    if(p.y + p.x > 1.0) {
        return sqrt(dot2(p - vec2(0.25, 0.75))) - sqrt(2.0) / 4.0;
    }
    return sqrt(min(dot2(p - vec2(0.00, 1.00)), dot2(p - 0.5 * max(p.x + p.y, 0.0)))) * sign(p.x - p.y);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Normalized pixel coordinates (from -1 to 1) with 0,0 in the centre
    vec2 uv = fragCoord / iResolution.xy * 2.0 - 1.0;
    // Take the aspect ratio of the canvas into account
    uv.x *= iResolution.x / iResolution.y;

    // Keep track of original distance towards center of canvas.
    vec2 uv0 = uv;

    // Fractal depth
    float fractalDepth = 4.0;

    // Final output color.
    vec3 finalColor = vec3(0.0);

    for(float i = 0.0; i < fractalDepth; i++) {
        uv = fract(uv * 2.0) - 0.5;

         // Build the star shape
        vec2 center = vec2(0.0, 0.0);
        float radius = 0.2;
        float distanceToShape = sdHexagram(uv - center, radius);

        float d = length(uv);
        float amountOfSineWaves = 3.0;
        // Multiply & devide by the amountOfSineWaves to compensate for the color intensity.
        d = sin(d * amountOfSineWaves + iTime) / amountOfSineWaves;
        d = abs(d);
        d = 0.02 / d;

    // Offset gradiant over time.
        float timeOffSet = 1.3;

        vec3 color1 = palette(length(uv0) + i * timeOffSet + iTime * timeOffSet);
        vec3 color2 = vec3(0, 0, 0);
    // Two colors
        finalColor = distanceToShape > 0.0 ? color2 : color1;
    }

    fragColor = vec4(finalColor, 1.0);
}
