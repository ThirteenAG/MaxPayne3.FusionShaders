sampler2D BumpSampler_layer0 : register(s1);
sampler2D BumpSampler_layer1 : register(s4);
sampler2D DynamicEnvironmentSampler : register(s13);
sampler2D SpecSampler_layer01 : register(s2);
sampler2D TextureSampler_layer0 : register(s0);
sampler2D TextureSampler_layer1 : register(s3);
float bumpiness : register(c4);
float fresnelRolloff : register(c6);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float reflectivePower : register(c5);
float specularColorFactor : register(c1);
float specularColorFactor1 : register(c3);
float specularFactor : register(c0);
float specularFactor1 : register(c2);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float3 color : COLOR;
	float3 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float3 texcoord6 : TEXCOORD6;
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
	float3 r6;
	r0.xyz = 1 + -i.color.xyz;
	r0.x = r0.y * r0.x;
	r0.y = r0.z * r0.x;
	r0.x = r0.x * i.color.z;
	r1 = i.texcoord.xyxx * float4(1, 1, 0, 0) + float4(0, 0, 0, -1.3);
	r2 = tex2Dbias(TextureSampler_layer0, r1);
	r1 = tex2Dbias(TextureSampler_layer1, r1);
	r1.xyz = r0.xxx * r1.xyz;
	r1.xyz = r2.xyz * r0.yyy + r1.xyz;
	r2 = tex2D(BumpSampler_layer0, i.texcoord.xy);
	r0.z = -r2.w + 1;
	r0.z = -r2.x + r0.z;
	r0.zw = (r0.zz >= 0) ? r2.wy : r2.xy;
	r2 = tex2D(BumpSampler_layer1, i.texcoord.xy);
	r1.w = -r2.w + 1;
	r1.w = -r2.x + r1.w;
	r2.xy = (r1.ww >= 0) ? r2.wy : r2.xy;
	r2.xy = r0.xx * r2.xy;
	r0.zw = r0.zw * r0.yy + r2.xy;
	r0.zw = r0.zw + -0.5;
	r0.zw = r0.zw * bumpiness.xx;
	r0.zw = r0.zw + r0.zw;
	r1.w = dot(r0.zw, -r0.zw) + 1;
	r2.x = max(r1.w, 0);
	r1.w = rsqrt(r2.x);
	r1.w = 1 / r1.w;
	r2.xyz = r0.zzz * i.texcoord4.xyz;
	r2.xyz = i.texcoord2.xyz * r1.www + r2.xyz;
	r2.xyz = r0.www * i.texcoord5.xyz + r2.xyz;
	r2.xyz = r2.xyz + 1E-05;
	r3 = normalize(r2.xyz);
	r2 = tex2D(SpecSampler_layer01, i.texcoord.xy);
	r4.x = r2.x * specularFactor.x;
	r4.y = r2.y * specularColorFactor.x;
	r2.x = r2.z * specularFactor1.x;
	r2.y = r2.w * specularColorFactor1.x;
	r0.xz = r0.xx * r2.xy;
	r0.xy = r4.xy * r0.yy + r0.xz;
	r2.xy = float2(1, 0);
	if (-reflectivePower.x < r2.y) {
		r0.z = saturate(r0.x * 0.015625);
		r4.w = r0.z * -4 + 4;
		r2.yzw = 1E-05 + i.texcoord6.xyz;
		r5 = normalize(r2.yzw);
		r0.z = dot(-r5.xyz, i.texcoord2.xyz);
		r0.z = r0.z + r0.z;
		r2.yzw = i.texcoord2.xyz * -r0.zzz + -r5.xyz;
		r2.yzw = r2.yzw + 1E-05;
		r6 = normalize(r2.yzw);
		r0.z = saturate(r6.z);
		r0.z = r0.z + 1;
		r0.z = r0.z + r0.z;
		r0.z = 1 / r0.z;
		r0.zw = r6.xy * r0.zz + 0.5;
		r4.xy = -r0.zw + 1;
		r4.z = 0;
		r4 = tex2Dlod(DynamicEnvironmentSampler, r4);
		r2.yzw = r4.xyz * r4.xyz;
		r2.yzw = r2.yzw * 16;
		r0.z = saturate(dot(r5.xyz, i.texcoord2.xyz));
		r0.w = r2.x + -fresnelRolloff.x;
		r0.z = -r0.z + 1.00001;
		r1.w = r0.z * r0.z;
		r1.w = r1.w * r1.w;
		r0.z = r0.z * r1.w;
		r0.z = fresnelRolloff.x * r0.z + r0.w;
		r2.xyz = r0.zzz * r2.yzw;
	} else {
		r2.xyz = 0;
	}
	r2.xyz = r2.xyz * reflectivePower.xxx;
	r0.z = saturate(globalScalars.w);
	r2.xyz = r0.zzz * r2.xyz;
	r0.z = saturate(-1 + i.texcoord3.w);
	r0.z = r0.z * globalScalars2.z;
	o.color.xyz = r1.xyz * i.texcoord3.xyz + r0.zzz;
	o.color1.xyz = r3.xyz * 0.5 + 0.5;
	r0.x = saturate(r0.x * 0.0051020407);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = rsqrt(r0.x);
	o.color2.y = 1 / r0.x;
	o.color2.z = gAmbientOcclusionEffect.w * i.texcoord3.w;
	r0.xzw = saturate(r2.xyz * 0.0625);
	r0.x = rsqrt(r0.x);
	r0.z = rsqrt(r0.z);
	r0.w = rsqrt(r0.w);
	o.color3.x = 1 / r0.x;
	o.color3.y = 1 / r0.z;
	o.color3.z = 1 / r0.w;
	o.color.w = 0;
	o.color1.w = globalScalars.x;
	o.color2.x = r0.y;
	o.color2.w = globalScalars.x;
	o.color3.w = gStencil.x;

	return o;
}
