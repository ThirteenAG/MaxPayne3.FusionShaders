sampler2D BumpSampler : register(s1);
sampler2D DiffuseSampler : register(s0);
float bumpiness : register(c199);
float4 gAdrenoFXVars : register(c68);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float parallaxScaleBias : register(c196);
float specularColorFactor : register(c198);
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
	float3 r4;
	float4 r5;
	r0 = tex2D(BumpSampler, i.texcoord.xy);
	r1.xyz = 1E-05 + i.texcoord7.xyz;
	r0.z = dot(r1.xyz, r1.xyz);
	r0.z = rsqrt(r0.z);
	r1.xy = r0.zz * r1.xy;
	r1.xy = -r1.xy * parallaxScaleBias.xx;
	r1.zw = i.texcoord.xy;
	r2.x = 1;
	r2.yzw = r0.xyw;
	for (int i0 = 0; i0 < 8; i0++) {
		r0.z = -r2.x + r2.w;
		r3.x = r2.x + -0.125;
		r4.xy = r1.xy * 0.125 + r1.zw;
		r5 = tex2D(BumpSampler, r4.xy);
		r1.zw = (r0.zz >= 0) ? r1.zw : r4.xy;
		r3.yzw = r5.xyw;
		r2 = (r0.z >= 0) ? r2 : r3;
	}
	r0 = tex2D(DiffuseSampler, r1.zw);
	r1.xy = r2.yz * 2 + -1;
	r1.xy = r1.xy * bumpiness.xx;
	r1.z = dot(r1.xy, -r1.xy) + 1;
	r2.x = max(r1.z, 0);
	r1.z = rsqrt(r2.x);
	r1.z = 1 / r1.z;
	r3.z = 1;
	r1.w = r3.z + -specularFactor.x;
	r3.xyz = r1.xxx * i.texcoord4.xyz;
	r3.xyz = r1.zzz * i.texcoord1.xyz + r3.xyz;
	r1.xyz = r1.yyy * i.texcoord5.xyz + r3.xyz;
	r1.xyz = r1.xyz + 1E-05;
	r3.xyz = normalize(r1.xyz);
	r1.x = dot(r2.yz, r2.yz) + -0.002;
	r1.x = (r1.x >= 0) ? 1 : 0;
	r2.xyz = r0.xyz * r1.xxx;
	r1.y = r1.x * i.color.x;
	o.color2.x = r1.x * specularColorFactor.x;
	r0.w = r0.w * i.color.w;
	r1.z = dot(r2.xyz, float3(0.2125, 0.7154, 0.0721));
	r4 = r0.xyz * r1.xxx + -r1.zzz;
	r4 = gAdrenoFXVars.xxx * r4.xyz + r1.zzz;
	r1.z = saturate(gAmbientOcclusionEffect.z + gAmbientOcclusionEffect.z);
	r0.xyz = r0.xyz * -r1.xxx + r4.xyz;
	r0.xyz = r1.zzz * r0.xyz + r2.xyz;
	r1.x = saturate(i.color.x * r1.x + -1);
	o.color.xyz = r1.xxx * globalScalars2.zzz + r0.xyz;
	o.color1.xyz = r3.xyz * 0.5 + 0.5;
	r0.x = specularFactor.x;
	r0.x = saturate(r0.x * 0.0051020407);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	o.color2.y = (r1.w >= 0) ? 0.071428575 : r0.x;
	r0.x = r0.w * globalScalars.x;
	o.color.w = r0.x;
	o.color1.w = r0.x;
	o.color2.w = r0.x;
	o.color2.z = r1.y;
	r0.yz = float2(-1, 0);
	o.color3 = abs(r0.zzzy) * gStencil.x;

	return o;
}
