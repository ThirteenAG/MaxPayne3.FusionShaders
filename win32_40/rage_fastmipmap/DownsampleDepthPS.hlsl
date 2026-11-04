SamplerState DepthTextureSampler0 : register(s15);
Texture2D DepthTextureSampler0_tex : register(t15);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	r0 = i.texcoord.xyxy + float4(-0.5, -0.5, 0.5, -0.5);
	r1 = DepthTextureSampler0_tex.Sample(DepthTextureSampler0, r0.xy);
	r0 = DepthTextureSampler0_tex.Sample(DepthTextureSampler0, r0.zw);
	r1.y = r0.x;
	r0 = i.texcoord.xyxy + float4(-0.5, 0.5, 0.5, 0.5);
	r2 = DepthTextureSampler0_tex.Sample(DepthTextureSampler0, r0.xy);
	r0 = DepthTextureSampler0_tex.Sample(DepthTextureSampler0, r0.zw);
	r2.y = r0.x;
	r0.xy = max(r1.xy, r2.xy);
	o = max(r0.y, r0.x);

	return o;
}
