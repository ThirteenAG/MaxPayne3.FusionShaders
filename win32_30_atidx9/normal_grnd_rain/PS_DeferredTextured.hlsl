sampler2D BumpSampler : register(s1);
sampler2D DiffuseSampler : register(s0);
sampler2D DynamicEnvironmentSampler : register(s13);
sampler2D PuddleMaskSampler : register(s2);
sampler2D WaterRainRippleNormalSampler : register(s14);
float4 WetDarken : register(c202);
float bumpiness : register(c198);
float fresnelRolloff : register(c200);
float4 gAdrenoFXVars : register(c68);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 gWaterGlobals : register(c64);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float reflectivePower : register(c199);
float specularColorFactor : register(c197);
float specularFactor : register(c196);

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
	float3 r3;
	float4 r4;
	float3 r5;
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
	r2.xw = float2(1, 0);
	r3.y = max(r2.x, specularFactor.x);
	r2.yz = WetDarken.ww * i.texcoord6.xy;
	r4 = tex2D(PuddleMaskSampler, r2.yz);
	r0.w = r4.x + gWaterGlobals.y;
	r0.w = saturate(r0.w + -i.color.y);
	r4.xyz = r1.xyz * WetDarken.xyz;
	r2.z = gWaterGlobals.z;
	r5.x = lerp(specularColorFactor.x, r2.z, r0.w);
	r5.y = lerp(r3.y, gWaterGlobals.w, r0.w);
	r2.yz = 0.3 * i.texcoord6.xy;
	r6 = tex2D(WaterRainRippleNormalSampler, r2.yz);
	r6.xyz = r6.xyz * 2 + -1;
	r6.xyz = r6.xyz * i.texcoord1.zzz + -r0.xyz;
	r6.xyz = r0.www * r6.xyz + r0.xyz;
	r6.xyz = r6.xyz + 1E-05;
	r7 = normalize(r6.xyz);
	r2.y = saturate(gWaterGlobals.y);
	r6.xyz = r1.xyz * WetDarken.xyz + -r1.xyz;
	r6.xyz = r2.yyy * r6.xyz + r1.xyz;
	r4.xyz = (-r0.www >= 0) ? r6.xyz : r4.xyz;
	r6.xyz = (-r0.www >= 0) ? r0.xyz : r7.xyz;
	r3.x = specularColorFactor.x;
	r2.yz = (-r0.ww >= 0) ? r3.xy : r5.xy;
	r0.xyz = (-i.color.yyy >= 0) ? r0.xyz : r6.xyz;
	r1.xyz = (-i.color.yyy >= 0) ? r1.xyz : r4.xyz;
	r2.yz = (-i.color.yy >= 0) ? r3.xy : r2.yz;
	r3 = r0.xxx * i.texcoord4.xyz;
	r0.xzw = r0.zzz * i.texcoord1.xyz + r3.xyz;
	r0.xyz = r0.yyy * i.texcoord5.xyz + r0.xzw;
	r0.xyz = r0.xyz + 1E-05;
	r3 = normalize(r0.xyz);
	if (-reflectivePower.x < r2.w) {
		r0.x = saturate(r2.z * 0.015625);
		r0.w = r0.x * -4 + 4;
		r4.xyz = 1E-05 + i.texcoord3.xyz;
		r5 = normalize(r4.xyz);
		r2.w = dot(-r5.xyz, r3.xyz);
		r2.w = r2.w + r2.w;
		r4.xyz = r3.xyz * -r2.www + -r5.xyz;
		r4.xyz = r4.xyz + 1E-05;
		r6.xyz = normalize(r4.xyz);
		r2.w = saturate(r6.z);
		r2.w = r2.w + 1;
		r2.w = r2.w + r2.w;
		r2.w = 1 / r2.w;
		r4.xy = r6.xy * r2.ww + 0.5;
		r0.xy = -r4.xy + 1;
		r0.z = 0;
		r0 = tex2Dlod(DynamicEnvironmentSampler, r0);
		r0.xyz = r0.xyz * r0.xyz;
		r0.xyz = r0.xyz * 16;
		r0.w = saturate(dot(r5.xyz, r3.xyz));
		r2.x = r2.x + -fresnelRolloff.x;
		r0.w = -r0.w + 1.00001;
		r2.w = pow(r0.w, 5.00001);
		r0.w = fresnelRolloff.x * r2.w + r2.x;
		r0.xyz = r0.www * r0.xyz;
	} else {
		r0.xyz = 0;
	}
	r0.xyz = r0.xyz * reflectivePower.xxx;
	r0.w = r1.w * i.color.w;
	r1.w = dot(r1.xyz, float3(0.2125, 0.7154, 0.0721));
	r4.xyz = lerp(r1.www, r1.xyz, gAdrenoFXVars.xxx);
	r1.w = saturate(gAmbientOcclusionEffect.z + gAmbientOcclusionEffect.z);
	r5 = lerp(r1.xyz, r4.xyz, r1.www);
	r1.x = saturate(-1 + i.color.x);
	o.color.xyz = r1.xxx * globalScalars2.zzz + r5.xyz;
	o.color1.xyz = r3.xyz * 0.5 + 0.5;
	r1.x = saturate(r2.z * 0.0051020407);
	r1.x = rsqrt(r1.x);
	o.color2.y = 1 / r1.x;
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
	o.color2.x = r2.y;
	o.color2.z = i.color.x;
	o.color2.w = r0.w;
	o.color3.w = gStencil.x;

	return o;
}
