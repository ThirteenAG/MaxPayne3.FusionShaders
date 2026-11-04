sampler2D BumpSampler : register(s1);
sampler2D DiffuseSampler : register(s0);
float bumpiness : register(c198);
float4 colorize : register(c47);
float4 gAdrenoFXVars : register(c68);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float specularColorFactor : register(c197);
float specularFactor : register(c196);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
};

struct PS_OUT
{
	float4 color : COLOR;
	float4 color1 : COLOR1;
	float4 color2 : COLOR2;
	float4 color3 : COLOR3;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	float4 r1;
	float3 r2;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r1 = r0 * colorize;
	r0.w = dot(r1.xyz, float3(0.2125, 0.7154, 0.0721));
	r2 = r0.xyz * colorize.xyz + -r0.www;
	r2 = gAdrenoFXVars.xxx * r2.xyz + r0.www;
	r0.xyz = r0.xyz * -colorize.xyz + r2.xyz;
	r0.w = saturate(gAmbientOcclusionEffect.z + gAmbientOcclusionEffect.z);
	r0.xyz = r0.www * r0.xyz + r1.xyz;
	r0.w = r1.w * i.color.w;
	r0.w = r0.w * globalScalars.x;
	r1.x = saturate(-1 + i.color.x);
	o.color.xyz = r1.xxx * globalScalars2.zzz + r0.xyz;
	r1 = tex2D(BumpSampler, i.texcoord.xy);
	r0.x = -r1.w + 1;
	r0.x = -r1.x + r0.x;
	r0.xy = (r0.xx >= 0) ? r1.wy : r1.xy;
	r0.xy = r0.xy * 2 + -1;
	r0.xy = r0.xy * bumpiness.xx;
	r0.z = dot(r0.xy, -r0.xy) + 1;
	r1.x = max(r0.z, 0);
	r0.z = rsqrt(r1.x);
	r0.z = 1 / r0.z;
	r1.xyz = r0.xxx * i.texcoord4.xyz;
	r1.xyz = r0.zzz * i.texcoord1.xyz + r1.xyz;
	r0.xyz = r0.yyy * i.texcoord5.xyz + r1.xyz;
	r0.xyz = r0.xyz + 1E-05;
	r1.xyz = normalize(r0.xyz);
	o.color1.xyz = r1.xyz * 0.5 + 0.5;
	r0.y = 0.0051020407;
	r0.x = saturate(r0.y * specularFactor.x);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r1.xw = float2(1, 0);
	r0.y = r1.x + -specularFactor.x;
	o.color2.y = (r0.y >= 0) ? 0.071428575 : r0.x;
	o.color.w = r0.w;
	o.color1.w = r0.w;
	o.color2.w = r0.w;
	o.color2.x = specularColorFactor.x;
	o.color2.z = i.color.x;
	o.color3 = r1.wwwx * gStencil.x;

	return o;
}
