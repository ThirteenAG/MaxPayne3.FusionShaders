sampler2D BumpSampler : register(s1);
sampler2D DiffuseSampler : register(s0);
float HardAlphaBlend : register(c200);
sampler2D SpecSampler : register(s2);
float bumpiness : register(c205);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float3 matDiffuseColor : register(c198);
float4 matDiffuseColor2 : register(c199);
float4 specMapExpMask : register(c204);
float3 specMapIntMask : register(c203);
float specularColorFactor : register(c202);
float specularFactor : register(c201);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float2 vpos : VPOS;
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
	float3 r2;
	r0 = tex2D(SpecSampler, i.texcoord.xy);
	r1.x = dot(r0.xyz, specMapIntMask.xyz);
	r0.x = dot(r0, specMapExpMask);
	r0.x = r0.x * specularFactor.x;
	r1.y = max(1, r0.x);
	r0.x = r1.y * matDiffuseColor2.w;
	r0.x = saturate(r0.x * 0.0051020407);
	r0.x = rsqrt(r0.x);
	o.color2.y = 1 / r0.x;
	r0.x = r1.x * specularColorFactor.x;
	o.color2.x = r0.x * matDiffuseColor2.w;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.xyz = r0.xyz * matDiffuseColor.xyz;
	r0 = r0 * i.texcoord2;
	r1.x = dot(i.texcoord2.xyz, float3(0.2125, 0.7154, 0.0721));
	r2.xz = globalScalars.xz;
	r1.y = r2.z * gAmbientOcclusionEffect.y;
	r1.z = saturate(r1.x * r1.y + -1);
	r1.x = r1.y * r1.x;
	o.color2.z = r1.x;
	o.color.xyz = r1.zzz * globalScalars2.zzz + r0.xyz;
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
	r0.x = i.vpos.y + i.vpos.x;
	r0.y = frac(r0.x);
	r0.z = (-r0.y >= 0) ? 0 : 1;
	r0.y = r0.x + -r0.y;
	r0.x = (r0.x >= 0) ? 0 : r0.z;
	r0.x = r0.x + r0.y;
	r0.yz = (r0.xx >= 0) ? float2(2, 0.5) : float2(-2, -0.5);
	r0.x = r0.z * r0.x;
	r0.x = frac(r0.x);
	r0.x = r0.x * r0.y;
	r0.y = frac(r0.x);
	r0.z = (-r0.y >= 0) ? 0 : 1;
	r0.y = r0.x + -r0.y;
	r0.x = (r0.x >= 0) ? 0 : r0.z;
	r0.x = r0.x + r0.y;
	r0.x = (-abs(r0.x) >= 0) ? 1 : 0;
	r0.y = r0.w * r2.x + -0.5019608;
	r0.z = r0.w * globalScalars.x;
	r0.y = r0.y * 20.078741 + -r0.z;
	r0.y = HardAlphaBlend.x * r0.y + r0.z;
	r0.y = -r0.y + 0.003921569;
	r0.y = (r0.y >= 0) ? 1 : 0;
	r0.x = r0.y + r0.x;
	r1 = (-r0.x >= 0) ? -0 : -1;
	clip(r1);
	o.color.w = r0.z;
	o.color1.w = r0.z;
	o.color2.w = r0.z;
	r0.xw = float2(1, 0);
	o.color3 = r0.wwwx * gStencil.x;

	return o;
}
