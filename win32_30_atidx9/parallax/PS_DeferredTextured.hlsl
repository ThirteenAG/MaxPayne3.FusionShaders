sampler2D BumpSampler : register(s1);
sampler2D DiffuseSampler : register(s0);
float bumpiness : register(c199);
float4 gAdrenoFXVars : register(c68);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float parallaxScaleBias : register(c196);
float specularColorFactor : register(c198);
float specularFactor : register(c197);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float3 texcoord7 : TEXCOORD7;
};

struct PS_OUT
{
	float4 color2 : COLOR2;
	float4 color : COLOR;
	float4 color1 : COLOR1;
	float4 color3 : COLOR3;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float3 r3;
	r0.xyz = 1E-05 + i.texcoord7.xyz;
	r0.z = dot(r0.xyz, r0.xyz);
	r0.z = rsqrt(r0.z);
	r0.xy = r0.zz * r0.xy;
	r1 = tex2D(BumpSampler, i.texcoord.xy);
	r2.yw = float2(0.5, -1);
	r0.z = r2.y * parallaxScaleBias.x;
	r0.z = r1.w * parallaxScaleBias.x + -r0.z;
	r0.xy = r0.zz * r0.xy + i.texcoord.xy;
	r1 = tex2D(BumpSampler, r0.xy);
	r0 = tex2D(DiffuseSampler, r0.xy);
	r1.z = dot(r1.xy, r1.xy) + -0.002;
	r1.xy = r1.xy * 2 + -1;
	r1.xy = r1.xy * bumpiness.xx;
	r1.z = (r1.z >= 0) ? 1 : 0;
	o.color2.x = r1.z * specularColorFactor.x;
	r2.xyz = r0.xyz * r1.zzz;
	r1.w = dot(r2.xyz, float3(0.2125, 0.7154, 0.0721));
	r3 = r0.xyz * r1.zzz + -r1.www;
	r3 = gAdrenoFXVars.xxx * r3.xyz + r1.www;
	r0.xyz = r0.xyz * -r1.zzz + r3.xyz;
	r0.w = r0.w * i.color.w;
	r0.w = r0.w * globalScalars.x;
	r1.w = saturate(gAmbientOcclusionEffect.z + gAmbientOcclusionEffect.z);
	r0.xyz = r1.www * r0.xyz + r2.xyz;
	r1.w = saturate(i.color.x * r1.z + -1);
	r1.z = r1.z * i.color.x;
	o.color2.z = r1.z;
	o.color.xyz = r1.www * globalScalars2.zzz + r0.xyz;
	r0.x = dot(r1.xy, -r1.xy) + 1;
	r1.z = max(r0.x, 0);
	r0.x = rsqrt(r1.z);
	r0.x = 1 / r0.x;
	r1.xzw = r1.xxx * i.texcoord4.xyz;
	r0.xyz = r0.xxx * i.texcoord1.xyz + r1.xzw;
	r0.xyz = r1.yyy * i.texcoord5.xyz + r0.xyz;
	r0.xyz = r0.xyz + 1E-05;
	r1.xyz = normalize(r0.xyz);
	o.color1.xyz = r1.xyz * 0.5 + 0.5;
	r1.xzw = float3(0, 1, 0.0051020407);
	r0.x = saturate(r1.w * specularFactor.x);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.y = -r2.w + -specularFactor.x;
	o.color2.y = (r0.y >= 0) ? 0.071428575 : r0.x;
	o.color.w = r0.w;
	o.color1.w = r0.w;
	o.color2.w = r0.w;
	o.color3 = r1.xxxz * gStencil.x;

	return o;
}
