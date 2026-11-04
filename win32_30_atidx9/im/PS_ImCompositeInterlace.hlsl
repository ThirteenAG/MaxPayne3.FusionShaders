float InterlaceIndex : register(c203);
sampler2D InterlaceMapSampler : register(s4);
float InterlaceTotalNum : register(c205);
float MaskAlphaReverse : register(c202);
sampler2D RenderMapPointSampler : register(s1);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float4 color : COLOR;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float3 r3;
	r0 = tex2D(RenderMapPointSampler, i.texcoord.xy);
	r1.xyz = -r0.xyz + 1;
	r2.xyz = i.color.xyz * 256 + -128;
	r1.xyz = r1.xyz * r2.xyz;
	r1.xyz = r1.xyz * 0.0078125;
	r0.w = r0.x * 0.0078125;
	r3 = r2.xyz * r0.www;
	r1.xyz = (-r2.xyz >= 0) ? r3.xyz : r1.xyz;
	r0.w = 1 / InterlaceTotalNum.x;
	r1.w = r0.w * InterlaceIndex.x;
	r2.x = r0.w * 0.5 + r1.w;
	r2.y = i.texcoord.y;
	r2 = tex2D(InterlaceMapSampler, r2.xy);
	r2.y = 1;
	r0.w = (-InterlaceTotalNum.x >= 0) ? r2.y : r2.w;
	r0.w = r0.w * i.color.w;
	r1.w = abs(MaskAlphaReverse.x);
	r0.w = (-r1.w >= 0) ? r0.w : 0;
	r1.xyz = (-r0.www >= 0) ? 0 : r1.xyz;
	r0.xyz = (-r0.www >= 0) ? 0 : r0.xyz;
	o.w = r0.w;
	o.xyz = r1.xyz + r0.xyz;

	return o;
}
