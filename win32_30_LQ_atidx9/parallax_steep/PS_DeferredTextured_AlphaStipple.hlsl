sampler2D BumpSampler : register(s1);
sampler2D DiffuseSampler : register(s0);
float bumpiness : register(c199);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float parallaxScaleBias : register(c196);
float specularColorFactor : register(c198);
float specularFactor : register(c197);
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
	for (int i0 = 0; i0 < 2; i0++) {
		r0.z = -r2.x + r2.w;
		r3.x = r2.x + -0.5;
		r4.xy = r1.xy * 0.5 + r1.zw;
		r5 = tex2D(BumpSampler, r4.xy);
		r1.zw = (r0.zz >= 0) ? r1.zw : r4.xy;
		r3.yzw = r5.xyw;
		r2 = (r0.z >= 0) ? r2 : r3;
	}
	r0 = tex2D(DiffuseSampler, r1.zw);
	r0.w = r0.w * i.color.w;
	r1.x = r0.w * globalScalars.x;
	r1.yz = 0.5 * i.vpos.xy;
	r1.yz = frac(abs(r1.yz));
	r1.yz = (i.vpos.xy >= 0) ? r1.yz : -r1.yz;
	r1.yz = r1.yz + r1.yz;
	r2.xw = frac(r1.yz);
	r1.yz = r1.yz + -r2.xw;
	r1.y = r1.z * 2 + r1.y;
	r3 = r1.y + float4(-0, -1, -2, -3);
	r3 = (-abs(r3) >= 0) ? 1 : 0;
	r1.y = dot(stipplePattern, r3);
	r0.w = r0.w * -globalScalars.x + r1.y;
	r3 = (r0.w >= 0) ? -1 : -0;
	clip(r3);
	r1.yz = r2.yz * 2 + -1;
	r1.yz = r1.yz * bumpiness.xx;
	r0.w = dot(r1.yz, -r1.yz) + 1;
	r1.w = max(r0.w, 0);
	r0.w = rsqrt(r1.w);
	r0.w = 1 / r0.w;
	r3.z = 1;
	r1.w = r3.z + -specularFactor.x;
	r3.xyz = r1.yyy * i.texcoord4.xyz;
	r3.xyz = r0.www * i.texcoord1.xyz + r3.xyz;
	r3.xyz = r1.zzz * i.texcoord5.xyz + r3.xyz;
	r3.xyz = r3.xyz + 1E-05;
	r4 = normalize(r3.xyz);
	r0.w = dot(r2.yz, r2.yz) + -0.002;
	r0.w = (r0.w >= 0) ? 1 : 0;
	r1.y = r0.w * i.color.x;
	o.color2.x = r0.w * specularColorFactor.x;
	r1.z = saturate(i.color.x * r0.w + -1);
	r1.z = r1.z * globalScalars2.z;
	o.color.xyz = r0.xyz * r0.www + r1.zzz;
	o.color1.xyz = r4.xyz * 0.5 + 0.5;
	r0.w = 0.0051020407;
	r0.x = saturate(r0.w * specularFactor.x);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	o.color2.y = (r1.w >= 0) ? 0.26726124 : r0.x;
	o.color2.z = r1.y * gAmbientOcclusionEffect.w;
	o.color.w = r1.x;
	o.color1.w = r1.x;
	o.color2.w = r1.x;
	r0.xy = float2(-0, -1);
	o.color3 = -r0.xxxy * gStencil.x;

	return o;
}
