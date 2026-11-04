sampler2D BumpSampler : register(s1);
sampler2D DiffuseSampler : register(s0);
sampler2D DynamicEnvironmentSampler : register(s13);
sampler2D SpecSampler : register(s2);
float bumpiness : register(c201);
float fresnelRolloff : register(c203);
float4 gAdrenoFXVars : register(c68);
float4 gAmbientOcclusionEffect : register(c63);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float reflectivePower : register(c202);
float4 specMapExpMask : register(c200);
float3 specMapIntMask : register(c199);
float3 specMapReflectMask : register(c204);
float specularFactor : register(c198);
float4 stipplePattern : register(c62);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord3 : TEXCOORD3;
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
	float4 r2;
	float4 r3;
	float4 r4;
	float3 r5;
	float3 r6;
	r0 = tex2D(BumpSampler, i.texcoord.xy);
	r0.z = -r0.w + 1;
	r0.z = -r0.x + r0.z;
	r0.xy = (r0.zz >= 0) ? r0.wy : r0.xy;
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.xy = r0.xy * 2 + -1;
	r0.xy = r0.xy * bumpiness.xx;
	r0.z = dot(r0.xy, -r0.xy) + 1;
	r2.x = max(r0.z, 0);
	r0.z = rsqrt(r2.x);
	r0.z = 1 / r0.z;
	r2 = tex2D(SpecSampler, i.texcoord.xy);
	r0.w = dot(r2, specMapExpMask);
	r0.w = r0.w * specularFactor.x;
	r2.w = max(1, r0.w);
	r3.xyz = r0.xxx * i.texcoord4.xyz;
	r0.xzw = r0.zzz * i.texcoord1.xyz + r3.xyz;
	r0.xyz = r0.yyy * i.texcoord5.xyz + r0.xzw;
	r0.xyz = r0.xyz + 1E-05;
	r3.xyz = normalize(r0.xyz);
	r0.xw = float2(1, 0);
	if (-reflectivePower.x < r0.w) {
		r0.y = saturate(r2.w * 0.015625);
		r4.w = r0.y * -4 + 4;
		r0.yzw = 1E-05 + i.texcoord3.xyz;
		r5 = normalize(r0.yzw);
		r0.y = dot(-r5.xyz, r3.xyz);
		r0.y = r0.y + r0.y;
		r0.yzw = r3.xyz * -r0.yyy + -r5.xyz;
		r0.yzw = r0.yzw + 1E-05;
		r6 = normalize(r0.yzw);
		r0.y = saturate(r6.z);
		r0.y = r0.y + 1;
		r0.y = r0.y + r0.y;
		r0.y = 1 / r0.y;
		r0.yz = r6.xy * r0.yy + 0.5;
		r4.xy = -r0.yz + 1;
		r4.z = 0;
		r4 = tex2Dlod(DynamicEnvironmentSampler, r4);
		r0.yzw = r4.xyz * r4.xyz;
		r0.yzw = r0.yzw * 16;
		r3.w = saturate(dot(r5.xyz, r3.xyz));
		r0.x = r0.x + -fresnelRolloff.x;
		r3.w = -r3.w + 1.00001;
		r4.x = pow(r3.w, 5.00001);
		r0.x = fresnelRolloff.x * r4.x + r0.x;
		r0.xyz = r0.xxx * r0.yzw;
	} else {
		r0.xyz = 0;
	}
	r0.w = r1.w * i.color.w;
	r1.w = r0.w * globalScalars.x;
	r4.xy = 0.5 * i.vpos.xy;
	r4.xy = frac(abs(r4.xy));
	r4.xy = (i.vpos.xy >= 0) ? r4.xy : -r4.xy;
	r4.xy = r4.xy + r4.xy;
	r4.zw = frac(r4.xy);
	r4.xy = -r4.zw + r4.xy;
	r3.w = r4.y * 2 + r4.x;
	r4 = r3.w + float4(-0, -1, -2, -3);
	r4 = (-abs(r4) >= 0) ? 1 : 0;
	r3.w = dot(stipplePattern, r4);
	r0.w = r0.w * -globalScalars.x + r3.w;
	r4 = (r0.w >= 0) ? -1 : -0;
	clip(r4);
	o.color2.x = dot(r2.xyz, specMapIntMask.xyz);
	r0.xyz = r0.xyz * reflectivePower.xxx;
	r0.w = dot(r2.xyz, specMapReflectMask.xyz);
	r0.xyz = r0.www * r0.xyz;
	r0.xyz = r0.xyz * globalScalars.www;
	r0.w = dot(r1.xyz, float3(0.2125, 0.7154, 0.0721));
	r2.xyz = lerp(r0.www, r1.xyz, gAdrenoFXVars.xxx);
	r0.w = saturate(gAmbientOcclusionEffect.z + gAmbientOcclusionEffect.z);
	r4.xyz = lerp(r1.xyz, r2.xyz, r0.www);
	r0.w = saturate(-1 + i.color.x);
	o.color.xyz = r0.www * globalScalars2.zzz + r4.xyz;
	o.color1.xyz = r3.xyz * 0.5 + 0.5;
	r0.w = saturate(r2.w * 0.0051020407);
	r0.w = rsqrt(r0.w);
	o.color2.y = 1 / r0.w;
	r0.xyz = saturate(r0.xyz * 0.0625);
	r0.x = rsqrt(r0.x);
	r0.y = rsqrt(r0.y);
	r0.z = rsqrt(r0.z);
	o.color3.x = 1 / r0.x;
	o.color3.y = 1 / r0.y;
	o.color3.z = 1 / r0.z;
	o.color.w = r1.w;
	o.color1.w = r1.w;
	o.color2.z = i.color.x;
	o.color2.w = r1.w;
	o.color3.w = r1.w;

	return o;
}
