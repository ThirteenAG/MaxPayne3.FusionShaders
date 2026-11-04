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
	float3 r2;
	float3 r3;
	float3 r4;
	r0.x = max(i.texcoord1.w, 0.100000001);
	r0.x = 1 / r0.x;
	r0.x = r0.x * -0.5;
	r0.xy = i.texcoord1.xy * r0.xx + float2(0.5, 0.5);
	r1.xy = (int2)i.sv_position.xy;
	r1.zw = int2(0, 0);
	r2 = gbufferTexture1.Load(r1.xyz).xyz;
	r0.zw = gbufferTexture2.Load(r1.xyw).xz;
	r1.xyz = asint(r2.xyz * float3(2, 2, 2) + float3(-1, -1, -1));
	r1.w = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r1.xyz = asint(asfloat(r1.xyz) * asfloat(r1.www) + -(i.texcoord2.xyz));
	r1.yw = asint(asfloat(r1.yy) * gWorldView[1].xy);
	r1.xy = asint(asfloat(r1.xx) * gWorldView[0].xy + asfloat(r1.yw));
	r1.xy = asint(asfloat(r1.zz) * gWorldView[2].xy + asfloat(r1.xy));
	r0.xy = asfloat(r1.xy) * -(mirrorNormalIntensity) + r0.xy;
	r0.xy = r0.xy * TextureSize.zz;
	r0.xy = max(r0.xy, TextureClamp.xy);
	r1.xy = asint(min(r0.xy, TextureClamp.zw));
	r2 = ReflectTextureSampler_tex.Sample(ReflectTextureSampler, asfloat(r1.xy)).xyz;
	r0.xy = float2(1, 1) / TextureSize.yx;
	r1.zw = asint(r0.xy + asfloat(r1.yx));
	r3 = ReflectTextureSampler_tex.Sample(ReflectTextureSampler, asfloat(r1.xz)).xyz;
	r4 = ReflectTextureSampler_tex.Sample(ReflectTextureSampler, asfloat(r1.wy)).xyz;
	r1.xyz = asint(ReflectTextureSampler_tex.Sample(ReflectTextureSampler, asfloat(r1.wz)).xyz);
	r2 = r2.xyz + r3.xyz;
	r2 = r4.xyz + r2.xyz;
	r1.xyz = asint(asfloat(r1.xyz) + r2.xyz);
	r1.xyz = asint(asfloat(r1.xyz) * float3(0.25, 0.25, 0.25));
	r1.xyz = asint(asfloat(r1.xyz) * asfloat(r1.xyz));
	r1.xyz = asint(asfloat(r1.xyz) * float3(16, 16, 16));
	r0.x = r0.z + -1;
	r0.y = saturate(r0.w * 3.33333325 + 0.0250000004);
	r0.z = saturate(mirrorSpecMaskIntensity);
	r0.x = r0.z * r0.x + 1;
	r0.xzw = asfloat(r1.xyz) * r0.xxx;
	r0.xzw = r0.xzw * mirrorIntensity;
	o.xyz = r0.yyy * r0.xzw;
	o.w = 1;

	return o;
}
