
// Source code for GLSL Perlin noise courtesy of:
// https://github.com/ashima/webgl-noise/wiki

uniform sampler2D tex0;
uniform sampler2D tex1;
uniform sampler2D tex2;
uniform float time;
uniform int mixType;

varying vec4 vertTexCoord;

vec3 mod289(vec3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 mod289(vec4 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 permute(vec4 x) {
     return mod289(((x*34.0)+1.0)*x);
}

vec4 taylorInvSqrt(vec4 r)
{
  return 1.79284291400159 - 0.85373472095314 * r;
}

float snoise(vec3 v)
  {
  const vec2 C = vec2(1.0/6.0, 1.0/3.0) ;
  const vec4 D = vec4(0.0, 0.5, 1.0, 2.0);

// First corner
  vec3 i = floor(v + dot(v, C.yyy) );
  vec3 x0 = v - i + dot(i, C.xxx) ;

// Other corners
  vec3 g = step(x0.yzx, x0.xyz);
  vec3 l = 1.0 - g;
  vec3 i1 = min( g.xyz, l.zxy );
  vec3 i2 = max( g.xyz, l.zxy );

  // x0 = x0 - 0.0 + 0.0 * C.xxx;
  // x1 = x0 - i1 + 1.0 * C.xxx;
  // x2 = x0 - i2 + 2.0 * C.xxx;
  // x3 = x0 - 1.0 + 3.0 * C.xxx;
  vec3 x1 = x0 - i1 + C.xxx;
  vec3 x2 = x0 - i2 + C.yyy; // 2.0*C.x = 1/3 = C.y
  vec3 x3 = x0 - D.yyy; // -1.0+3.0*C.x = -0.5 = -D.y

// Permutations
  i = mod289(i);
  vec4 p = permute( permute( permute(
             i.z + vec4(0.0, i1.z, i2.z, 1.0 ))
           + i.y + vec4(0.0, i1.y, i2.y, 1.0 ))
           + i.x + vec4(0.0, i1.x, i2.x, 1.0 ));

// Gradients: 7x7 points over a square, mapped onto an octahedron.
// The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)
  float n_ = 0.142857142857; // 1.0/7.0
  vec3 ns = n_ * D.wyz - D.xzx;

  vec4 j = p - 49.0 * floor(p * ns.z * ns.z); // mod(p,7*7)

  vec4 x_ = floor(j * ns.z);
  vec4 y_ = floor(j - 7.0 * x_ ); // mod(j,N)

  vec4 x = x_ *ns.x + ns.yyyy;
  vec4 y = y_ *ns.x + ns.yyyy;
  vec4 h = 1.0 - abs(x) - abs(y);

  vec4 b0 = vec4( x.xy, y.xy );
  vec4 b1 = vec4( x.zw, y.zw );

  //vec4 s0 = vec4(lessThan(b0,0.0))*2.0 - 1.0;
  //vec4 s1 = vec4(lessThan(b1,0.0))*2.0 - 1.0;
  vec4 s0 = floor(b0)*2.0 + 1.0;
  vec4 s1 = floor(b1)*2.0 + 1.0;
  vec4 sh = -step(h, vec4(0.0));

  vec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;
  vec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;

  vec3 p0 = vec3(a0.xy,h.x);
  vec3 p1 = vec3(a0.zw,h.y);
  vec3 p2 = vec3(a1.xy,h.z);
  vec3 p3 = vec3(a1.zw,h.w);

//Normalise gradients
  vec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));
  p0 *= norm.x;
  p1 *= norm.y;
  p2 *= norm.z;
  p3 *= norm.w;

// Mix final noise value
  vec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);
  m = m * m;
  return 42.0 * dot( m*m, vec4( dot(p0,x0), dot(p1,x1),
                                dot(p2,x2), dot(p3,x3) ) );
}

void main(void) {
	vec2 p = vertTexCoord.xy; // put texture coordinates in vec2 p for convenience
	
	vec4 col0 = texture2D(tex0, p); // color of texture 0
	vec4 col1 = texture2D(tex1, p); // color of texture 1
	vec4 col2 = texture2D(tex2, p); // color of texture 2
	
	// differentiated vec3 input parameters for the noise based on texture coordinates, time and a random shift
	vec3 q0 = vec3(p, time);
	vec3 q1 = vec3(time + 2500.0, p);
	vec3 q2 = vec3(p, time + 5000.0);
	
	// 3x noise based on 3x input, map noise output from range (-1, 1) to range (0, 1)
	float noise0 = 0.5*(snoise( q0 ) + 1.0);
	float noise1 = 0.5*(snoise( q1 ) + 1.0);
	float noise2 = 0.5*(snoise( q2 ) + 1.0);
	
	// vec4 to hold the final color of this fragment/pixel
	vec4 colorFinal;

	// do something, depending on the mixType (0=subtle, 1=regular, 2=obvious)
	if (mixType==0) {

		// add all 3x noise values
		float totalNoise = noise0 + noise1 + noise2;

		// calculate relative noise weights (adding up to 1)
		noise0 /= totalNoise;
		noise1 /= totalNoise;
		noise2 /= totalNoise;

		// multiply 3x texture color by relative noise weights
		col0 *= noise0;
		col1 *= noise1;
		col2 *= noise2;
		
		// construct final color by adding up the noise-weighted colors from the three textures
		colorFinal = col0 + col1 + col2;
		
	} else if (mixType==1) {

	    // noise0 depends which textures are mixed
		// interpolation is determined by the relative position within the specific 0.33 range
		// 0.00 - 0.33 = texture 0 and 1
		// 0.33 - 0.66 = texture 1 and 2
		// 0.66 - 1.00 = texture 2 and 0
		if (noise0 < 0.33) {
			colorFinal = mix(col0, col1, noise0/0.33);
		} else if (noise0 < 0.66) {
			colorFinal = mix(col1, col2, (noise0-0.33)/0.33);
		} else {
			colorFinal = mix(col2, col0, (noise0-0.66)/0.33);
		}
		
	} else {
	
	    // noise0 depends which textures are mixed
		// interpolation is determined by one of the noise values
		// 0.00 - 0.33 = texture 0 and 1, interpolation by noise value 1
		// 0.33 - 0.66 = texture 1 and 2, interpolation by noise value 2
		// 0.66 - 1.00 = texture 2 and 0, interpolation by noise value 0
		if (noise0 < 0.33) {
			colorFinal = mix(col0, col1, noise1);
		} else if (noise0 < 0.66) {
			colorFinal = mix(col1, col2, noise2);
		} else {
			colorFinal = mix(col2, col0, noise0);
		}
		
	}
	
	// set the fragment color to the final calculated color
	gl_FragColor = colorFinal;
}
