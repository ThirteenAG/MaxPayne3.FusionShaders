sampler2D BumpSampler : register(s2);
sampler2D DiffuseSampler : register(s0);
sampler2D EnvironmentSampler : register(s4);
sampler2D SpecSampler : register(s3);
float bumpiness : register(c203);
float fresnelRolloff : register(c205);
float4 gAmbientOcclusionEffect : register(c63);
float4 globalFogColorN : register(c50);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float3 matDiffuseColor : register(c197);
float4 matDiffuseColor2 : register(c198);
float reflectivePower : register(c204);
float4 specMapExpMask : register(c202);
float3 specMapIntMask : register(c201);
float specularColorFactor : register(c200);
float specularFactor : register(c199);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
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
	float3 r1;
	float4 r2;
	float3 r3;
	r0 = tex2D(SpecSampler, i.texcoord.xy);
	r1.x = dot(r0.xyz, specMapIntMask.xyz);
	r0.x = dot(r0, specMapExpMask);
	r0.x = r0.x * specularFactor.x;
	r1.y = max(1, r0.x);
	r0.x = r1.y * matDiffuseColor2.w;
	r0.x = saturate(r0.x * 0.0051020407);
	r0.x = rsqrt(r0.x);
	o.color2.y = 1 / r0.x;
	r0.x = saturate(r1.x * specularColorFactor.x);
	o.color2.x = r0.x * matDiffuseColor2.w;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.xyz = r0.xyz * matDiffuseColor.xyz;
	r0 = r0 * i.texcoord2;
	r1.x = dot(i.texcoord2.xyz, float3(0.2125, 0.7154, 0.0721));
	r1.z = globalScalars.z;
	r1.y = r1.z * gAmbientOcclusionEffect.y;
	r1.z = saturate(r1.x * r1.y + -1);
	r2.z = r1.y * r1.x;
	o.color.xyz = r1.zzz * globalScalars2.zzz + r0.xyz;
	r2.w = r0.w * globalScalars.x;
	r0 = tex2D(BumpSampler, i.texcoord.xy);
	r0.z = -r0.w + 1;
	r0.z = -r0.x + r0.z;
	r0.xy = (r0.zz >= 0) ? r0.wy : r0.xy;
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
	r0.xyz = 1E-05 + i.texcoord3.xyz;
	r3 = normalize(r0.xyz);
	r0.x = dot(-r3.xyz, r1.xyz);
	r0.x = r0.x + r0.x;
	r0.xyz = r1.xyz * -r0.xxx + -r3.xyz;
	r0.w = saturate(dot(r3.xyz, r1.xyz));
	r0.w = -r0.w + 1.00001;
	r1.x = pow(r0.w, 5.00001);
	r0.xyz = r0.xyz + 1E-05;
	r3 = normalize(r0.xyz);
	r0.x = saturate(r3.z);
	r0.x = r0.x + 1;
	r0.x = r0.x + r0.x;
	r0.x = 1 / r0.x;
	r0.xy = r3.xy * r0.xx + 0.5;
	r0.xy = -r0.xy + 1;
	r0.zw = 0;
	r0 = tex2Dlod(EnvironmentSampler, r0);
	r0.xyz = r0.xyz * r0.xyz;
	r0.xyz = r0.xyz * 16;
	r2.x = 1;
	r0.w = r2.x + -fresnelRolloff.x;
	r0.w = fresnelRolloff.x * r1.x + r0.w;
	r0.xyz = r0.www * r0.xyz;
	r0.xyz = r0.xyz * reflectivePower.xxx;
	r0.xyz = r0.xyz * globalFogColorN.www;
	r0.xyz = r0.xyz * matDiffuseColor2.www;
	r0.xyz = saturate(r0.xyz * 0.0625);
	r0.x = rsqrt(r0.x);
	o.color3.x = 1 / r0.x;
	r0.x = rsqrt(r0.y);
	r0.y = rsqrt(r0.z);
	o.color3.z = 1 / r0.y;
	o.color3.y = 1 / r0.x;
	o.color.w = r2.w;
	o.color1.w = r2.w;
	o.color2.zw = r2.zw;
	o.color3.w = r2.w;

	return o;
}
