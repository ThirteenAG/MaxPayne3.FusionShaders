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
	r0 = i.texcoord.xyxy + float4(-0.5, -0.5, 0.5, -0.5);
	r0.x = DepthTextureSampler0_tex.Sample(DepthTextureSampler0, r0.xy).x;
	r0.y = DepthTextureSampler0_tex.Sample(DepthTextureSampler0, r0.zw).x;
	r1 = i.texcoord.xyxy + float4(-0.5, 0.5, 0.5, 0.5);
	r0.z = DepthTextureSampler0_tex.Sample(DepthTextureSampler0, r1.xy).x;
	r0.w = DepthTextureSampler0_tex.Sample(DepthTextureSampler0, r1.zw).x;
	r0.xy = max(r0.zw, r0.xy);
	o = max(r0.y, r0.x);

	return o;
}
