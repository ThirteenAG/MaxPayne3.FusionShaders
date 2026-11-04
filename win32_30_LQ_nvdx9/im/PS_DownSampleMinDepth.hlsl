sampler2D DepthMapPointSampler : register(s4);
float4 globalScreenSize : register(c41);

struct PS_OUT
{
	float depth : DEPTH;
	float4 color : COLOR;
};

PS_OUT main(float2 texcoord : TEXCOORD)
{
	PS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float r3;
	r0 = globalScreenSize.zwzw + texcoord.xyxy;
	r1.zw = globalScreenSize.zw;
	r2 = r1.zwzw * float4(-0.5, -0.5, 0.5, -0.5) + r0.zwzw;
	r0 = r1.zwzw * float4(-0.5, 0.5, 0.5, 0.5) + r0;
	r1 = tex2D(DepthMapPointSampler, r2.xy);
	r2 = tex2D(DepthMapPointSampler, r2.zw);
	r3 = min(r2.x, r1.x);
	r1 = tex2D(DepthMapPointSampler, r0.xy);
	r0 = tex2D(DepthMapPointSampler, r0.zw);
	r2.x = min(r0.x, r1.x);
	o.depth = min(r2.x, r3.x);
	o.color = float4(1, 0, 0, 1);

	return o;
}
