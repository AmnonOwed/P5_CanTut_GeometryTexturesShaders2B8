
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform sampler2D EarthDay;
uniform sampler2D EarthNight;
uniform sampler2D EarthGloss;
uniform sampler2D EarthClouds;
uniform float Time;
uniform float useClouds;

varying float Diffuse;
varying vec3  Specular;

void main() {
	float gloss	   = texture2D(EarthGloss, vertTexCoord.st).r;
	float clouds   = texture2D(EarthClouds, vec2(vertTexCoord.s+Time, vertTexCoord.t)).r;
	clouds *= useClouds;
	
    vec3 daytime   = (texture2D(EarthDay, vertTexCoord.st).rgb * Diffuse + Specular * gloss) * (1.0 - clouds) + clouds * Diffuse;
    vec3 nighttime = texture2D(EarthNight, vertTexCoord.st).rgb * (1.0 - clouds) * 2.0;

    vec3 color = daytime;

    if (Diffuse < 0.1)
        color = mix(nighttime, daytime, (Diffuse + 0.1) * 5.0);

    gl_FragColor = vec4(color, 1.0);
}
