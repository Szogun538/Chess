shader_type canvas_item;

// You can edit these sliders right in the Godot Inspector!
uniform float speed : hint_range(0.1, 5.0) = 0.5;
uniform float frequency : hint_range(1.0, 20.0) = 8.0;
uniform float amplitude : hint_range(0.01, 0.5) = 0.1;
uniform vec3 color_shift = vec3(0.5, 0.5, 0.5); 

void fragment() {
    // 1. Center the coordinates (normally they go from 0 to 1, we want -0.5 to 0.5)
    vec2 uv = UV - 0.5;

    // 2. Create the swirling distortion using math (Sine and Cosine waves)
    float time = TIME * speed;
    float wave_x = sin(uv.y * frequency + time) * amplitude;
    float wave_y = cos(uv.x * frequency - time) * amplitude;
    
    // 3. Apply the distortion to our coordinates
    uv.x += wave_x;
    uv.y += wave_y;
    
    // 4. Calculate how far each pixel is from the center (creates a radial tunnel vibe)
    float dist = length(uv);
    
    // 5. Generate shifting psychedelic colors based on the distorted math
    // We use a cosine wave formula to smoothly cycle through RGB values
    vec3 trippy_color = color_shift + 0.5 * sin(6.28318 * (uv.xyx + vec3(time, time + 0.33, time + 0.67)));
    
    // Add a dark pulse from the center
    trippy_color *= smoothstep(0.8, 0.1, dist);
    
    // 6. Paint the pixel
    COLOR = vec4(trippy_color, 1.0);
}
