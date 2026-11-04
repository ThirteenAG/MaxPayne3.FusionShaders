sampler2D BumpSampler : register(s2);
sampler2D DiffuseSampler : register(s0);
sampler2D SpecSampler : register(s3);
float bumpiness : register(c202);
float4 gAmbientOcclusionEffect : register(c63);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float parallaxScaleBias : register(c197);
float4 specMapExpMask : register(c201);
float3 specMapIntMask : register(c200);
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
	r3 = tex2D(SpecSampler, i.texcoord.xy);
	r2.x = dot(r3.xyz, specMapIntMask.xyz);
	r2.y = dot(r3, specMapExpMask);
	o.color2.x = r1.w * r2.x;
	r2.x = saturate(i.color.x * r1.w + -1);
	r2.x = r2.x * globalScalars2.z;
	o.color.xyz = r0.xyz * r1.www + r2.xxx;
	r0.x = r0.w * i.color.w;
	r0.y = r1.w * i.color.x;
	o.color2.z = r0.y * gAmbientOcclusionEffect.w;
	r0.yz = r1.xy * 2 + -1;
	r0.w = r0.x * r1.z;
	r0.x = r0.x * globalScalars.x;
	o.color1.w = r0.w * globalScalars.x;
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
	r0.y = r2.y * specularFactor.x;
	r0.z = r2.y * -specularFactor.x + -r2.w;
	r0.y = saturate(r0.y * 0.0051020407);
	r0.y = rsqrt(r0.y);
	r0.y = 1 / r0.y;
	r0.y = rsqrt(r0.y);
	r0.y = 1 / r0.y;
	o.color2.y = (r0.z >= 0) ? 0.26726124 : r0.y;
	o.color.w = r0.x;
	o.color2.w = r0.x;
	o.color3 = r0.x * float4(0, 0, 0, 1);

	return o;
}
