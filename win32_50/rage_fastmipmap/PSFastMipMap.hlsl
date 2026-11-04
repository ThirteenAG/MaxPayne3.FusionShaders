cbuffer _Globals : register(b1)
{
	float4 TexelSize : packoffset(c38);
};

SamplerState BaseSampler : register(s3);
Texture2D BaseSampler_tex : register(t3);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float2 texcoord1 : TEXCOORD1;
	float3 texcoord2 : TEXCOORD2;
};

struct PS_OUT
{
	float4 sv_target : SV_Target;
	float4 sv_target1 : SV_Target1;
	float4 sv_target2 : SV_Target2;
	float4 sv_target3 : SV_Target3;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	r0.z = -(TexelSize.x) * 0.5 + i.texcoord.x;
	r0.xyw = TexelSize.xyy * float3(0.5, 0.5, 0.5) + i.texcoord.xyy;
	r1 = BaseSampler_tex.Sample(BaseSampler, r0.zw);
	r0 = BaseSampler_tex.Sample(BaseSampler, r0.xy);
	r0 = r1 + r0;
	r1.x = TexelSize.x * 0.5 + i.texcoord.x;
	r1.yzw = -(TexelSize.yxy) * float3(0.5, 0.5, 0.5) + i.texcoord.yxy;
	r2 = BaseSampler_tex.Sample(BaseSampler, r1.xy);
	r1 = BaseSampler_tex.Sample(BaseSampler, r1.zw);
	r0 = r0 + r2;
	r0 = r1 + r0;
	r0 = r0 * float4(0.25, 0.25, 0.25, 0.25);
	o.sv_target = r0;
	o.sv_target1 = r0;
	o.sv_target2 = r0;
	o.sv_target3 = r0;

	return o;
}
