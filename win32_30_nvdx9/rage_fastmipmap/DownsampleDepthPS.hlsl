sampler2D DepthTextureSampler0 : register(s15);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	r0 = float4(-0.5, 0.5, 0.5, 0.5) + texcoord.xyxy;
	r1 = tex2D(DepthTextureSampler0, r0.xy);
	r0 = tex2D(DepthTextureSampler0, r0.zw);
	r1.y = r0.x;
	r0 = float4(-0.5, -0.5, 0.5, -0.5) + texcoord.xyxy;
	r2 = tex2D(DepthTextureSampler0, r0.xy);
	r0 = tex2D(DepthTextureSampler0, r0.zw);
	r2.y = r0.x;
	r0.xy = max(r2.xy, r1.xy);
	o = max(r0.x, r0.y);

	return o;
}
