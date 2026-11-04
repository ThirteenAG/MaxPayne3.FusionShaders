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
float4 stipplePattern : register(c62);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float3 texcoord7 : TEXCOORD7;
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
	float4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	float3 r6;
	r0 = tex2D(BumpSampler, i.texcoord.xy);
	r0.xyz = 1E-05 + i.texcoord7.xyz;
	r0.z = dot(r0.xyz, r0.xyz);
	r0.z = rsqrt(r0.z);
	r0.xy = r0.zz * r0.xy;
	r1.yw = float2(0.5, -1);
	r0.z = r1.y * parallaxScaleBias.x;
	r0.z = r0.w * parallaxScaleBias.x + -r0.z;
	r0.xy = saturate(r0.zz * r0.xy + i.texcoord.xy);
	r2 = tex2D(DiffuseSampler, r0.xy);
	r0.z = r2.w * i.color.w;
	r3.w = r0.z * globalScalars.x;
	r1.xy = 0.5 * i.vpos.xy;
	r1.xy = frac(abs(r1.xy));
	r1.xy = (i.vpos.xy >= 0) ? r1.xy : -r1.xy;
	r1.xy = r1.xy + r1.xy;
	r3.xy = frac(r1.xy);
	r1.xy = r1.xy + -r3.xy;
	r0.w = r1.y * 2 + r1.x;
	r4 = r0.w + float4(-0, -1, -2, -3);
	r4 = (-abs(r4) >= 0) ? 1 : 0;
	r0.w = dot(stipplePattern, r4);
	r0.w = r0.z * -globalScalars.x + r0.w;
	r4 = (r0.w >= 0) ? -1 : -0;
	clip(r4);
	r4 = tex2D(BumpSampler, r0.xy);
	r0.xy = r4.xy * 2 + -1;
	r0.xy = r0.xy * bumpiness.xx;
	r0.w = dot(r0.xy, -r0.xy) + 1;
	r1.x = max(r0.w, 0);
	r0.w = rsqrt(r1.x);
	r0.w = 1 / r0.w;
	r5 = tex2D(SpecSampler, i.texcoord.xy);
	r1.x = dot(r5, specMapExpMask);
	r1.y = r1.x * specularFactor.x;
	r1.z = dot(r5.xyz, specMapIntMask.xyz);
	r1.x = r1.x * -specularFactor.x + -r1.w;
	r5.xyz = r0.xxx * i.texcoord4.xyz;
	r5.xyz = r0.www * i.texcoord1.xyz + r5.xyz;
	r0.xyw = r0.yyy * i.texcoord5.xyz + r5.xyz;
	r0.xyw = r0.xyw + 1E-05;
	r5.xyz = normalize(r0.xyw);
	r0.x = dot(r4.xy, r4.xy) + -0.002;
	r0.x = (r0.x >= 0) ? 1 : 0;
	r4.xyw = r0.xxx * r2.xyz;
	r3.z = r0.x * i.color.x;
	o.color2.x = r0.x * r1.z;
	r0.y = dot(r4.xyw, float3(0.2125, 0.7154, 0.0721));
	r6 = r2.xyz * r0.xxx + -r0.yyy;
	r6 = gAdrenoFXVars.xxx * r6.xyz + r0.yyy;
	r0.y = saturate(gAmbientOcclusionEffect.z + gAmbientOcclusionEffect.z);
	r2.xyz = r2.xyz * -r0.xxx + r6.xyz;
	r2.xyz = r0.yyy * r2.xyz + r4.xyw;
	r0.x = saturate(i.color.x * r0.x + -1);
	o.color.xyz = r0.xxx * globalScalars2.zzz + r2.xyz;
	o.color1.xyz = r5.xyz * 0.5 + 0.5;
	r0.x = saturate(r1.y * 0.0051020407);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	o.color2.y = (r1.x >= 0) ? 0.071428575 : r0.x;
	r0.x = r0.z * r4.z;
	o.color1.w = r0.x * globalScalars.x;
	o.color.w = r3.w;
	o.color2.zw = r3.zw;
	o.color3 = r3.w * float4(0, 0, 0, 1);

	return o;
}
