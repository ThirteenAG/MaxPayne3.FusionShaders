cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
};

cbuffer MirrorParam : register(b4)
{
	float mirrorNormalIntensity : packoffset(c0);
	float mirrorSpecMaskIntensity : packoffset(c0.y);
	float mirrorIntensity : packoffset(c0.z);
	float4 TextureSize : packoffset(c1);
	float4 TextureClamp : packoffset(c2);
};

SamplerState ReflectTextureSampler : register(s14);
Texture2D gbufferTexture1 : register(t12);
Texture2D gbufferTexture2 : register(t13);
Texture2D ReflectTextureSampler_tex : register(t14);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord2 : TEXCOORD2;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	int4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	r0.x = max(i.texcoord1.w, 0.100000001);
	r0.x = 1 / r0.x;
	r0.x = r0.x * -0.5;
	r0.xy = i.texcoord1.xy * r0.xx + float2(0.5, 0.5);
	r1.xy = (int2)i.sv_position.xy;
	r1.zw = int2(0, 0);
	r2 = gbufferTexture1.Load(r1.xyz);
	r1 = asint(gbufferTexture2.Load(r1.xyw));
	r2.xyz = r2.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
	r0.z = dot(r2.xyz, r2.xyz);
	r0.z = rsqrt(r0.z);
	r2.xyz = r2.xyz * r0.zzz + -(i.texcoord2.xyz);
	r0.zw = r2.yy * gWorldView[1].xy;
	r0.zw = r2.xx * gWorldView[0].xy + r0.zw;
	r0.zw = r2.zz * gWorldView[2].xy + r0.zw;
	r0.xy = r0.zw * -(mirrorNormalIntensity) + r0.xy;
	r0.xy = r0.xy * TextureSize.zz;
	r0.xy = max(r0.xy, TextureClamp.xy);
	r0.xy = min(r0.xy, TextureClamp.zw);
	r2 = ReflectTextureSampler_tex.Sample(ReflectTextureSampler, r0.xy);
	r1.yw = asint(float2(1, 1) / TextureSize.yx);
	r0.zw = r0.yx + asfloat(r1.yw);
	r3 = ReflectTextureSampler_tex.Sample(ReflectTextureSampler, r0.xz);
	r4 = ReflectTextureSampler_tex.Sample(ReflectTextureSampler, r0.wy);
	r0 = ReflectTextureSampler_tex.Sample(ReflectTextureSampler, r0.wz);
	r2.xyz = r2.xyz + r3.xyz;
	r2.xyz = r4.xyz + r2.xyz;
	r0.xyz = r0.xyz + r2.xyz;
	r0.xyz = r0.xyz * float3(0.25, 0.25, 0.25);
	r0.xyz = r0.xyz * r0.xyz;
	r0.xyz = r0.xyz * float3(16, 16, 16);
	r0.w = asfloat(r1.x) + -1;
	r1.x = asint(saturate(asfloat(r1.z) * 3.33333325 + 0.0250000004));
	r1.y = asint(saturate(mirrorSpecMaskIntensity));
	r0.w = asfloat(r1.y) * r0.w + 1;
	r0.xyz = r0.xyz * r0.www;
	r0.xyz = r0.xyz * mirrorIntensity;
	o.xyz = asfloat(r1.xxx) * r0.xyz;
	o.w = 1;

	return o;
}
