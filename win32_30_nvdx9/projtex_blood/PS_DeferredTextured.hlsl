sampler2D DynamicEnvironmentSampler : register(s13);
float4 EnvBloodData : register(c203);
sampler2D EnvBloodSampler : register(s2);
float fresnelRolloff : register(c202);
float4 gAmbientOcclusionEffect : register(c63);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float reflectivePower : register(c201);
float specularColorFactor : register(c199);
float specularFactor : register(c198);

struct PS_IN
{
	float4 color : COLOR;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord3 : TEXCOORD3;
	float2 texcoord7 : TEXCOORD7;
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
	r0.xyz = 1E-05 + i.texcoord1.xyz;
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	r1.yw = float2(0, 1);
	if (-EnvBloodData.w < r1.y) {
		r2 = tex2D(EnvBloodSampler, i.texcoord7.xy);
		r1.xz = saturate(i.texcoord7.xy);
		r1.x = r1.z + r1.x;
		r1.x = r1.x + -i.texcoord7.x;
		r1.x = r1.x + -i.texcoord7.y;
		r1.x = -abs(r1.x) + 0.001;
		r2.xyz = (r1.xxx >= 0) ? r2.wxy : 0;
		r2 = r2.xyzz;
	} else {
		r2 = 0;
	}
	r0.xyz = r0.xyz * r0.www + 1E-05;
	r3 = normalize(r0.xyz);
	r0.x = max(r1.w, specularFactor.x);
	if (-reflectivePower.x < r1.y) {
		r0.y = saturate(r0.x * 0.015625);
		r4.w = r0.y * -4 + 4;
		r0.yzw = 1E-05 + i.texcoord3.xyz;
		r1.xyz = normalize(r0.yzw);
		r0.y = dot(-r1.xyz, r3.xyz);
		r0.y = r0.y + r0.y;
		r0.yzw = r3.xyz * -r0.yyy + -r1.xyz;
		r0.yzw = r0.yzw + 1E-05;
		r5 = normalize(r0.yzw);
		r0.y = saturate(r5.z);
		r0.y = r0.y + 1;
		r0.y = r0.y + r0.y;
		r0.y = 1 / r0.y;
		r0.yz = r5.xy * r0.yy + 0.5;
		r4.xy = -r0.yz + 1;
		r4.z = 0;
		r4 = tex2Dlod(DynamicEnvironmentSampler, r4);
		r0.yzw = r4.xyz * r4.xyz;
		r0.yzw = r0.yzw * 16;
		r1.x = saturate(dot(r1.xyz, r3.xyz));
		r1.y = r1.w + -fresnelRolloff.x;
		r1.x = -r1.x + 1.00001;
		r1.z = r1.x * r1.x;
		r1.z = r1.z * r1.z;
		r1.x = r1.z * r1.x;
		r1.x = fresnelRolloff.x * r1.x + r1.y;
		r0.yzw = r0.yzw * r1.xxx;
	} else {
		r0.yzw = 0;
	}
	r0.yzw = r0.yzw * reflectivePower.xxx;
	r0.yzw = r0.yzw * globalScalars.www;
	r1 = r2.x + -0.01;
	clip(r1);
	r1.x = r2.x * i.color.w;
	r1.y = saturate(-1 + i.color.x);
	o.color.xyz = r1.yyy * globalScalars2.zzz + r2.yzw;
	o.color1.xyz = r3.xyz * 0.5 + 0.5;
	r0 = saturate(r0 * float4(0.0051020407, 0.0625, 0.0625, 0.0625));
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = rsqrt(r0.x);
	o.color2.y = 1 / r0.x;
	o.color2.z = gAmbientOcclusionEffect.w * i.color.x;
	r0.x = r1.x * globalScalars.x;
	r0.y = rsqrt(r0.y);
	r0.z = rsqrt(r0.z);
	r0.w = rsqrt(r0.w);
	o.color3.x = 1 / r0.y;
	o.color3.y = 1 / r0.z;
	o.color3.z = 1 / r0.w;
	o.color.w = r0.x;
	o.color1.w = r0.x;
	o.color2.x = specularColorFactor.x;
	o.color2.w = r0.x;
	o.color3.w = r0.x;

	return o;
}
