sampler2D BumpSampler : register(s1);
sampler2D DiffuseSampler : register(s0);
sampler2D DynamicEnvironmentSampler : register(s13);
sampler2D PuddleMaskSampler : register(s2);
sampler2D SpecSampler : register(s3);
sampler2D WaterRainRippleNormalSampler : register(s14);
float4 WetDarken : register(c206);
float bumpiness : register(c201);
float fresnelRolloff : register(c203);
float4 gAmbientOcclusionEffect : register(c63);
float4 gWaterGlobals : register(c64);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float reflectivePower : register(c202);
float4 specMapExpMask : register(c200);
float3 specMapIntMask : register(c199);
float3 specMapReflectMask : register(c204);
float specularFactor : register(c198);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float2 texcoord6 : TEXCOORD6;
};

struct PS_OUT
{
	float4 color : COLOR;
	float4 color1 : COLOR1;
	float4 color2 : COLOR2;
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
	float4 r6;
	float3 r7;
	r0 = tex2D(BumpSampler, i.texcoord.xy);
	r0.z = -r0.w + 1;
	r0.z = -r0.x + r0.z;
	r0.xy = (r0.zz >= 0) ? r0.wy : r0.xy;
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.xy = r0.xy * 2 + -1;
	r0.xy = r0.xy * bumpiness.xx;
	r0.w = dot(r0.xy, -r0.xy) + 1;
	r2.x = max(r0.w, 0);
	r0.w = rsqrt(r2.x);
	r0.z = 1 / r0.w;
	r2 = tex2D(SpecSampler, i.texcoord.xy);
	r0.w = dot(r2, specMapExpMask);
	r0.w = r0.w * specularFactor.x;
	r3.x = dot(r2.xyz, specMapIntMask.xyz);
	r3.y = max(1, r0.w);
	r3.zw = WetDarken.ww * i.texcoord6.xy;
	r4 = tex2D(PuddleMaskSampler, r3.zw);
	r0.w = r4.x + gWaterGlobals.y;
	r0.w = saturate(r0.w + -i.color.y);
	r4.xyz = r1.xyz * WetDarken.xyz;
	r5.xy = lerp(r3.xy, gWaterGlobals.zw, r0.ww);
	r3.zw = 0.3 * i.texcoord6.xy;
	r6 = tex2D(WaterRainRippleNormalSampler, r3.zw);
	r6.xyz = r6.xyz * 2 + -1;
	r6.xyz = r6.xyz * i.texcoord1.zzz + -r0.xyz;
	r6.xyz = r0.www * r6.xyz + r0.xyz;
	r6.xyz = r6.xyz + 1E-05;
	r7 = normalize(r6.xyz);
	r2.w = saturate(gWaterGlobals.y);
	r6.xyz = r1.xyz * WetDarken.xyz + -r1.xyz;
	r6.xyz = r2.www * r6.xyz + r1.xyz;
	r4.xyz = (-r0.www >= 0) ? r6.xyz : r4.xyz;
	r6.xyz = (-r0.www >= 0) ? r0.xyz : r7.xyz;
	r3.zw = (-r0.ww >= 0) ? r3.xy : r5.xy;
	r0.xyz = (-i.color.yyy >= 0) ? r0.xyz : r6.xyz;
	r1.xyz = (-i.color.yyy >= 0) ? r1.xyz : r4.xyz;
	r3.xy = (-i.color.yy >= 0) ? r3.xy : r3.zw;
	r4.xyz = r0.xxx * i.texcoord4.xyz;
	r0.xzw = r0.zzz * i.texcoord1.xyz + r4.xyz;
	r0.xyz = r0.yyy * i.texcoord5.xyz + r0.xzw;
	r0.xyz = r0.xyz + 1E-05;
	r4.xyz = normalize(r0.xyz);
	r0.xw = float2(1, 0);
	if (-reflectivePower.x < r0.w) {
		r0.y = saturate(r3.y * 0.015625);
		r5.w = r0.y * -4 + 4;
		r0.yzw = 1E-05 + i.texcoord3.xyz;
		r6.xyz = normalize(r0.yzw);
		r0.y = dot(-r6.xyz, r4.xyz);
		r0.y = r0.y + r0.y;
		r0.yzw = r4.xyz * -r0.yyy + -r6.xyz;
		r0.yzw = r0.yzw + 1E-05;
		r7 = normalize(r0.yzw);
		r0.y = saturate(r7.z);
		r0.y = r0.y + 1;
		r0.y = r0.y + r0.y;
		r0.y = 1 / r0.y;
		r0.yz = r7.xy * r0.yy + 0.5;
		r5.xy = -r0.yz + 1;
		r5.z = 0;
		r5 = tex2Dlod(DynamicEnvironmentSampler, r5);
		r0.yzw = r5.xyz * r5.xyz;
		r0.yzw = r0.yzw * 16;
		r2.w = saturate(dot(r6.xyz, r4.xyz));
		r0.x = r0.x + -fresnelRolloff.x;
		r2.w = -r2.w + 1.00001;
		r3.z = r2.w * r2.w;
		r3.z = r3.z * r3.z;
		r2.w = r2.w * r3.z;
		r0.x = fresnelRolloff.x * r2.w + r0.x;
		r0.xyz = r0.xxx * r0.yzw;
	} else {
		r0.xyz = 0;
	}
	r0.xyz = r0.xyz * reflectivePower.xxx;
	r0.w = dot(r2.xyz, specMapReflectMask.xyz);
	r0.xyz = r0.www * r0.xyz;
	r0.w = r1.w * i.color.w;
	r1.w = saturate(-1 + i.color.x);
	o.color.xyz = r1.www * globalScalars2.zzz + r1.xyz;
	o.color1.xyz = r4.xyz * 0.5 + 0.5;
	r1.x = saturate(r3.y * 0.0051020407);
	r1.x = rsqrt(r1.x);
	r1.x = 1 / r1.x;
	r1.x = rsqrt(r1.x);
	o.color2.y = 1 / r1.x;
	o.color2.z = gAmbientOcclusionEffect.w * i.color.x;
	r0 = r0 * globalScalars.wwwx;
	r0.xyz = saturate(r0.xyz * 0.0625);
	r0.x = rsqrt(r0.x);
	r0.y = rsqrt(r0.y);
	r0.z = rsqrt(r0.z);
	o.color3.x = 1 / r0.x;
	o.color3.y = 1 / r0.y;
	o.color3.z = 1 / r0.z;
	o.color.w = r0.w;
	o.color1.w = r0.w;
	o.color2.x = r3.x;
	o.color2.w = r0.w;
	o.color3.w = r0.w;

	return o;
}
