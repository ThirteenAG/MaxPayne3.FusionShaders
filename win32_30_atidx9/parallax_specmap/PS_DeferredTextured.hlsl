sampler2D BumpSampler : register(s1);
sampler2D DiffuseSampler : register(s0);
sampler2D SpecSampler : register(s2);
float bumpiness : register(c200);
float4 gAdrenoFXVars : register(c68);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float parallaxScaleBias : register(c196);
float4 specMapExpMask : register(c199);
float3 specMapIntMask : register(c198);
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
	float4 r3;
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
	r0.yz = r0.ww * r0.yz + i.texcoord.xy;
	r2 = tex2D(BumpSampler, r0.yz);
	r3 = tex2D(DiffuseSampler, r0.yz);
	r0.y = dot(r2.xy, r2.xy) + -0.002;
	r0.zw = r2.xy * 2 + -1;
	r0.zw = r0.zw * bumpiness.xx;
	r0.y = (r0.y >= 0) ? 1 : 0;
	o.color2.x = r0.y * r1.x;
	r1.xyz = r0.yyy * r3.xyz;
	r2.x = dot(r1.xyz, float3(0.2125, 0.7154, 0.0721));
	r2.yzw = r3.xyz * r0.yyy + -r2.xxx;
	r2.xyz = gAdrenoFXVars.xxx * r2.yzw + r2.xxx;
	r2.xyz = r3.xyz * -r0.yyy + r2.xyz;
	r2.w = r3.w * i.color.w;
	r2.w = r2.w * globalScalars.x;
	r3.x = saturate(gAmbientOcclusionEffect.z + gAmbientOcclusionEffect.z);
	r1.xyz = r3.xxx * r2.xyz + r1.xyz;
	r2.x = saturate(i.color.x * r0.y + -1);
	r0.y = r0.y * i.color.x;
	o.color2.z = r0.y;
	o.color.xyz = r2.xxx * globalScalars2.zzz + r1.xyz;
	r0.y = dot(r0.zw, -r0.zw) + 1;
	r1.x = max(r0.y, 0);
	r0.y = rsqrt(r1.x);
	r0.y = 1 / r0.y;
	r1.xyz = r0.zzz * i.texcoord4.xyz;
	r1.xyz = r0.yyy * i.texcoord1.xyz + r1.xyz;
	r0.yzw = r0.www * i.texcoord5.xyz + r1.xyz;
	r0.yzw = r0.yzw + 1E-05;
	r1.xyz = normalize(r0.yzw);
	o.color1.xyz = r1.xyz * 0.5 + 0.5;
	r0.y = r0.x * specularFactor.x;
	r0.x = r0.x * -specularFactor.x + -r1.w;
	r0.y = saturate(r0.y * 0.0051020407);
	r0.y = rsqrt(r0.y);
	r0.y = 1 / r0.y;
	o.color2.y = (r0.x >= 0) ? 0.071428575 : r0.y;
	o.color.w = r2.w;
	o.color1.w = r2.w;
	o.color2.w = r2.w;
	r0.xz = float2(0, 1);
	o.color3 = r0.xxxz * gStencil.x;

	return o;
}
