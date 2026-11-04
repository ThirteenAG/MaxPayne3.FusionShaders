sampler2D BumpSampler : register(s2);
sampler2D DiffuseSampler : register(s0);
sampler2D EnvironmentSampler : register(s4);
sampler2D SpecSampler : register(s3);
float bumpiness : register(c206);
float fresnelRolloff : register(c209);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalFogColorN : register(c50);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float3 matDiffuseColor : register(c200);
float4 matDiffuseColor2 : register(c201);
float reflectivePower : register(c207);
float4 specMapExpMask : register(c205);
float3 specMapIntMask : register(c204);
float specularColorFactor : register(c203);
float specularFactor : register(c202);

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
	r0.x = saturate(r1.x * specularColorFactor.x);
	o.color2.x = r0.x * matDiffuseColor2.w;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.xyz = r0.xyz * matDiffuseColor.xyz;
	r0 = r0 * i.texcoord2;
	r1.x = dot(i.texcoord2.xyz, float3(0.2125, 0.7154, 0.0721));
	r1.z = globalScalars.z;
	r1.y = r1.z * gAmbientOcclusionEffect.y;
	r1.z = saturate(r1.x * r1.y + -1);
	r1.x = r1.y * r1.x;
	o.color2.z = r1.x;
	o.color.xyz = r1.zzz * globalScalars2.zzz + r0.xyz;
	r0.x = r0.w * globalScalars.x;
	r1 = tex2D(BumpSampler, i.texcoord.xy);
	r0.y = -r1.w + 1;
	r0.y = -r1.x + r0.y;
	r0.yz = (r0.yy >= 0) ? r1.wy : r1.xy;
	r0.yz = r0.yz * 2 + -1;
	r0.yz = r0.yz * bumpiness.xx;
	r0.w = dot(r0.yz, -r0.yz) + 1;
	r1.x = max(r0.w, 0);
	r0.w = rsqrt(r1.x);
	r0.w = 1 / r0.w;
	r1.xyz = r0.yyy * i.texcoord4.xyz;
	r1.xyz = r0.www * i.texcoord1.xyz + r1.xyz;
	r0.yzw = r0.zzz * i.texcoord5.xyz + r1.xyz;
	r0.yzw = r0.yzw + 1E-05;
	r1.xyz = normalize(r0.yzw);
	o.color1.xyz = r1.xyz * 0.5 + 0.5;
	r0.yzw = 1E-05 + i.texcoord3.xyz;
	r2 = normalize(r0.yzw);
	r0.y = dot(-r2.xyz, r1.xyz);
	r0.y = r0.y + r0.y;
	r0.yzw = r1.xyz * -r0.yyy + -r2.xyz;
	r1.x = saturate(dot(r2.xyz, r1.xyz));
	r1.x = -r1.x + 1.00001;
	r2.x = pow(r1.x, 5.00001);
	r0.yzw = r0.yzw + 1E-05;
	r1.xyz = normalize(r0.yzw);
	r0.y = saturate(r1.z);
	r0.y = r0.y + 1;
	r0.y = r0.y + r0.y;
	r0.y = 1 / r0.y;
	r0.yz = r1.xy * r0.yy + 0.5;
	r1.xy = -r0.yz + 1;
	r1.zw = 0;
	r1 = tex2Dlod(EnvironmentSampler, r1);
	r0.yzw = r1.xyz * r1.xyz;
	r0.yzw = r0.yzw * 16;
	r1.x = 1;
	r1.x = r1.x + -fresnelRolloff.x;
	r1.x = fresnelRolloff.x * r2.x + r1.x;
	r0.yzw = r0.yzw * r1.xxx;
	r0.yzw = r0.yzw * reflectivePower.xxx;
	r0.yzw = r0.yzw * globalFogColorN.www;
	r0.yzw = r0.yzw * matDiffuseColor2.www;
	r0.yzw = saturate(r0.yzw * 0.0625);
	r0.y = rsqrt(r0.y);
	o.color3.x = 1 / r0.y;
	r0.y = rsqrt(r0.z);
	r0.z = rsqrt(r0.w);
	o.color3.z = 1 / r0.z;
	o.color3.y = 1 / r0.y;
	o.color.w = r0.x;
	o.color1.w = r0.x;
	o.color2.w = r0.x;
	o.color3.w = gStencil.x;

	return o;
}
