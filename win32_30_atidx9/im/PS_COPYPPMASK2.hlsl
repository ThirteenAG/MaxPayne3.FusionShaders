float InterlaceIndex : register(c203);
sampler2D InterlaceMapSampler : register(s4);
float InterlaceTotalNum : register(c205);
sampler2D RenderMapPointSampler : register(s1);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	r0.x = 1 / InterlaceTotalNum.x;
	r0.y = r0.x * InterlaceIndex.x;
	r0.x = r0.x * 0.5 + r0.y;
	r0.y = texcoord.y;
	r0 = tex2D(InterlaceMapSampler, r0.xy);
	r0.x = InterlaceTotalNum.x;
	o.y = (-r0.x >= 0) ? 1 : r0.w;
	r0 = tex2D(RenderMapPointSampler, texcoord.xy);
	o.xzw = r0.xzw;

	return o;
}
