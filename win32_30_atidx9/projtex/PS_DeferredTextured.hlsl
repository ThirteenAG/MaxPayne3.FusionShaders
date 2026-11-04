sampler2D BumpSampler : register(s2);
sampler2D DiffuseSampler : register(s0);
float bumpiness : register(c201);
float4 gAdrenoFXVars : register(c68);
float4 gAmbientOcclusionEffect : register(c63);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float parallaxScaleBias : register(c197);
float specularColorFactor : register(c200);
float specularFactor : register(c199);

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
	float4 r3;
	r0.xyz = 1E-05 + i.texcoord7.xyz;
	r0.z = dot(r0.xyz, r0.xyz);
	r0.z = rsqrt(r0.z);
	r0.xy = r0.zz * r0.xy;
	r1 = tex2D(BumpSampler, i.texcoord.xy);
	r2.yw = float2(0.5, -1);
	r0.z = r2.y * parallaxScaleBias.x;
	r0.z = r1.w * parallaxScaleBias.x + -r0.z;
	r0.xy = saturate(r0.zz * r0.xy + i.texcoord.xy);
	r1 = tex2D(BumpSampler, r0.xy);
	r0 = tex2D(DiffuseSampler, r0.xy);
	r1.w = dot(r1.xy, r1.xy) + -0.002;
	r1.w = (r1.w >= 0) ? 1 : 0;
	o.color2.x = r1.w * specularColorFactor.x;
	r2.xyz = r0.xyz * r1.www;
	r3.x = dot(r2.xyz, float3(0.2125, 0.7154, 0.0721));
	r3.yzw = r0.xyz * r1.www + -r3.xxx;
	r3.xyz = gAdrenoFXVars.xxx * r3.yzw + r3.xxx;
	r0.xyz = r0.xyz * -r1.www + r3.xyz;
	r0.w = r0.w * i.color.w;
	r3.x = saturate(gAmbientOcclusionEffect.z + gAmbientOcclusionEffect.z);
	r0.xyz = r3.xxx * r0.xyz + r2.xyz;
	r2.x = saturate(i.color.x * r1.w + -1);
	r3.z = r1.w * i.color.x;
	o.color.xyz = r2.xxx * globalScalars2.zzz + r0.xyz;
	r0.xy = r1.xy * 2 + -1;
	r0.z = r0.w * r1.z;
	r3.w = r0.w * globalScalars.x;
	o.color1.w = r0.z * globalScalars.x;
	r0.xy = r0.xy * bumpiness.xx;
	r0.z = dot(r0.xy, -r0.xy) + 1;
	r1.x = max(r0.z, 0);
	r0.z = rsqrt(r1.x);
	r0.z = 1 / r0.z;
	r1.xyz = r0.xxx * i.texcoord4.xyz;
	r0.xzw = r0.zzz * i.texcoord1.xyz + r1.xyz;
	r0.xyz = r0.yyy * i.texcoord5.xyz + r0.xzw;
	r0.xyz = r0.xyz + 1E-05;
	r1.xyz = normalize(r0.xyz);
	o.color1.xyz = r1.xyz * 0.5 + 0.5;
	r0.w = 0.0051020407;
	r0.x = saturate(r0.w * specularFactor.x);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.y = -r2.w + -specularFactor.x;
	o.color2.y = (r0.y >= 0) ? 0.071428575 : r0.x;
	o.color.w = r3.w;
	o.color2.zw = r3.zw;
	o.color3 = r3.w * float4(0, 0, 0, 1);

	return o;
}
