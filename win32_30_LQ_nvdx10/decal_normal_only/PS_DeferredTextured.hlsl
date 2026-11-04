sampler2D BumpSampler : register(s1);
float bumpiness : register(c200);
float4 globalScalars : register(c35);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float4 color : COLOR;
};

struct PS_OUT
{
	float4 color1 : COLOR1;
	float4 color : COLOR;
	float4 color2 : COLOR2;
	float4 color3 : COLOR3;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	float3 r1;
	r0 = tex2D(BumpSampler, i.texcoord.xy);
	r1.x = -r0.w + 1;
	r1.x = -r0.x + r1.x;
	r0.xy = (r1.xx >= 0) ? r0.wy : r0.xy;
	r0.z = r0.z * i.color.w;
	o.color1.w = r0.z * globalScalars.x;
	r0.xy = r0.xy * 2 + -1;
	r0.xy = r0.xy * bumpiness.xx;
	r0.z = dot(r0.xy, -r0.xy) + 1;
	r1.x = max(r0.z, 0);
	r0.z = rsqrt(r1.x);
	r0.z = 1 / r0.z;
	r1 = r0.xxx * i.texcoord4.xyz;
	r0.xzw = r0.zzz * i.texcoord1.xyz + r1.xyz;
	r0.xyz = r0.yyy * i.texcoord5.xyz + r0.xzw;
	r0.xyz = r0.xyz + 1E-05;
	r1 = normalize(r0.xyz);
	o.color1.xyz = r1.xyz * 0.5 + 0.5;
	o.color = 0;
	o.color2 = 0;
	o.color3 = 0;

	return o;
}
