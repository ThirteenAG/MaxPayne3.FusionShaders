sampler2D BumpSampler : register(s2);
sampler2D DiffuseSampler : register(s0);
sampler2D SpecSampler : register(s3);
float bumpiness : register(c202);
float4 gAdrenoFXVars : register(c68);
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
	float3 r4;
	r0 = tex2D(SpecSampler, i.texcoord.xy);
	r1.x = dot(r0.xyz, specMapIntMask.xyz);
	r0.x = dot(r0, specMapExpMask);
	r0.yzw = 1E-05 + i.texcoord7.xyz;
	r0.w = dot(r0.yzw, r0.yzw);
	r0.w = rsqrt(r0.w);
	r0.yz = r0.ww * r0.yz;
	r2 = tex2D(BumpSampler, i.texcoord.xy);
	r1.yw = float2(0.5, -1);
	r0.w = r1.y * parallaxScaleBias.x;
	r0.w = r2.w * parallaxScaleBias.x + -r0.w;
	r0.yz = saturate(r0.ww * r0.yz + i.texcoord.xy);
	r2 = tex2D(BumpSampler, r0.yz);
	r3 = tex2D(DiffuseSampler, r0.yz);
	r0.y = dot(r2.xy, r2.xy) + -0.002;
	r0.y = (r0.y >= 0) ? 1 : 0;
	o.color2.x = r0.y * r1.x;
	r1.xyz = r0.yyy * r3.xyz;
	r0.z = dot(r1.xyz, float3(0.2125, 0.7154, 0.0721));
	r4 = r3.xyz * r0.yyy + -r0.zzz;
	r4 = gAdrenoFXVars.xxx * r4.xyz + r0.zzz;
	r3.xyz = r3.xyz * -r0.yyy + r4.xyz;
	r0.z = r3.w * i.color.w;
	r0.w = saturate(gAmbientOcclusionEffect.z + gAmbientOcclusionEffect.z);
	r1.xyz = r0.www * r3.xyz + r1.xyz;
	r0.w = saturate(i.color.x * r0.y + -1);
	r3.z = r0.y * i.color.x;
	o.color.xyz = r0.www * globalScalars2.zzz + r1.xyz;
	r0.yw = r2.xy * 2 + -1;
	r1.x = r0.z * r2.z;
	r3.w = r0.z * globalScalars.x;
	o.color1.w = r1.x * globalScalars.x;
	r0.yz = r0.yw * bumpiness.xx;
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
	r0.y = r0.x * specularFactor.x;
	r0.x = r0.x * -specularFactor.x + -r1.w;
	r0.y = saturate(r0.y * 0.0051020407);
	r0.y = rsqrt(r0.y);
	r0.y = 1 / r0.y;
	o.color2.y = (r0.x >= 0) ? 0.071428575 : r0.y;
	o.color.w = r3.w;
	o.color2.zw = r3.zw;
	o.color3 = r3.w * float4(0, 0, 0, 1);

	return o;
}
