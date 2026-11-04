sampler2D BumpSampler : register(s1);
sampler2D DiffuseSampler : register(s0);
sampler2D SpecSampler : register(s2);
float bumpiness : register(c199);
float4 gAdrenoFXVars : register(c68);
float4 gAmbientOcclusionEffect : register(c63);
float4 gDistFadeParams : register(c97);
float4 gStencil : register(c61);
row_major float4x4 gViewInverse : register(c12);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float4 specMapExpMask : register(c198);
float3 specMapIntMask : register(c197);
float specularFactor : register(c196);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float3 texcoord6 : TEXCOORD6;
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
	r0 = tex2D(SpecSampler, i.texcoord.xy);
	o.color2.x = dot(r0.xyz, specMapIntMask.xyz);
	r0.x = dot(r0, specMapExpMask);
	r0.y = saturate(gAmbientOcclusionEffect.z + gAmbientOcclusionEffect.z);
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.z = dot(r1.xyz, float3(0.2125, 0.7154, 0.0721));
	r2.xyz = lerp(r0.zzz, r1.xyz, gAdrenoFXVars.xxx);
	r3 = lerp(r1.xyz, r2.xyz, r0.yyy);
	r0.y = r1.w * i.color.w;
	r0.z = saturate(-1 + i.color.x);
	o.color.xyz = r0.zzz * globalScalars2.zzz + r3.xyz;
	r1 = tex2D(BumpSampler, i.texcoord.xy);
	r0.z = -r1.w + 1;
	r0.z = -r1.x + r0.z;
	r0.zw = (r0.zz >= 0) ? r1.wy : r1.xy;
	r0.zw = r0.zw * 2 + -1;
	r0.zw = r0.zw * bumpiness.xx;
	r1.x = dot(r0.zw, -r0.zw) + 1;
	r2.x = max(r1.x, 0);
	r1.x = rsqrt(r2.x);
	r1.x = 1 / r1.x;
	r1.yzw = r0.zzz * i.texcoord4.xyz;
	r1.xyz = r1.xxx * i.texcoord1.xyz + r1.yzw;
	r1.xyz = r0.www * i.texcoord5.xyz + r1.xyz;
	r1.xyz = r1.xyz + 1E-05;
	r2.xyz = normalize(r1.xyz);
	o.color1.xyz = r2.xyz * 0.5 + 0.5;
	r0.z = r0.x * specularFactor.x;
	r1.xw = float2(1, 0);
	r0.x = r0.x * -specularFactor.x + r1.x;
	r0.z = saturate(r0.z * 0.0051020407);
	r0.z = rsqrt(r0.z);
	r0.z = 1 / r0.z;
	o.color2.y = (r0.x >= 0) ? 0.071428575 : r0.z;
	r0.w = -0.5;
	r0.x = r0.y * globalScalars.x + r0.w;
	r0.y = r0.y * globalScalars.x;
	r2 = min(r0.x, 0);
	r0.x = (r0.x >= 0) ? 1 : r0.y;
	clip(r2);
	r2.xyz = -gViewInverse[3].xyz + i.texcoord6.xyz;
	r0.z = dot(r2.xyz, r2.xyz);
	r0.z = rsqrt(r0.z);
	r0.z = 1 / r0.z;
	r0.zw = r0.zz + float2(-0.65, -0.9);
	r0.z = saturate(r0.z);
	r0.z = r0.z + -1;
	r0.z = (r0.w >= 0) ? r0.z : -0.75;
	r0.z = gDistFadeParams.x * r0.z + r1.x;
	o.color.w = r0.z * r0.x;
	o.color1.w = r0.y;
	o.color2.w = r0.y;
	o.color2.z = i.color.x;
	o.color3 = r1.wwwx * gStencil.x;

	return o;
}
