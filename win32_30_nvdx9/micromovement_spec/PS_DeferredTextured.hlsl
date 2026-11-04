sampler2D DiffuseSampler : register(s0);
sampler2D SpecSampler : register(s1);
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
	r0 = tex2D(SpecSampler, i.texcoord.xy);
	o.color2.x = dot(r0.xyz, specMapIntMask.xyz);
	r0.x = dot(r0, specMapExpMask);
	r0.y = saturate(-1 + i.color.x);
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	o.color.xyz = r0.yyy * globalScalars2.zzz + r1.xyz;
	r0.y = r1.w * i.color.w;
	r1.xyz = 1E-05 + i.texcoord1.xyz;
	r2.xyz = normalize(r1.xyz);
	o.color1.xyz = r2.xyz * 0.5 + 0.5;
	r0.z = r0.x * specularFactor.x;
	r1.yw = float2(1, 0.5);
	r0.x = r0.x * -specularFactor.x + r1.y;
	r0.z = saturate(r0.z * 0.0051020407);
	r0.z = rsqrt(r0.z);
	r0.z = 1 / r0.z;
	r0.z = rsqrt(r0.z);
	r0.z = 1 / r0.z;
	o.color2.y = (r0.x >= 0) ? 0.26726124 : r0.z;
	o.color2.z = gAmbientOcclusionEffect.w * i.color.x;
	r0.x = r0.y * globalScalars.x + -r1.w;
	r0.y = r0.y * globalScalars.x;
	r2 = (r0.x >= 0) ? 0 : -1;
	clip(r2);
	r1.xzw = -gViewInverse[3].xyz + i.texcoord6.xyz;
	r0.z = dot(r1.xzw, r1.xzw);
	r0.z = rsqrt(r0.z);
	r0.z = 1 / r0.z;
	r0.zw = r0.zz + float2(-0.65, -0.9);
	r0.z = saturate(r0.z);
	r0.z = r0.z + -1;
	r0.z = (r0.w >= 0) ? r0.z : -0.75;
	r0.z = gDistFadeParams.x * r0.z + r1.y;
	o.color.w = (r0.x >= 0) ? r0.z : 0;
	o.color1.w = r0.y;
	o.color2.w = r0.y;
	r0.zw = float2(0, -1);
	o.color3 = abs(r0.zzzw) * gStencil.x;

	return o;
}
