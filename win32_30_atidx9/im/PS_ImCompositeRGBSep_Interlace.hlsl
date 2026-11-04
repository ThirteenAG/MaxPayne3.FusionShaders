float2 BlueOff : register(c209);
float2 GreenOff : register(c207);
float InterlaceIndex : register(c203);
sampler2D InterlaceMapSampler : register(s4);
float InterlaceTotalNum : register(c205);
float MaskAlphaReverse : register(c202);
float2 RedOff : register(c206);
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
	float3 r2;
	float3 r3;
	r0.xy = RedOff.xy + i.texcoord.xy;
	r0 = tex2D(RenderMapPointSampler, r0.xy);
	r1.xy = GreenOff.xy + i.texcoord.xy;
	r1 = tex2D(RenderMapPointSampler, r1.xy);
	r0.y = r1.y;
	r1.xy = BlueOff.xy + i.texcoord.xy;
	r1 = tex2D(RenderMapPointSampler, r1.xy);
	r0.z = r1.z;
	r0.w = 1 / InterlaceTotalNum.x;
	r1.x = r0.w * InterlaceIndex.x;
	r1.x = r0.w * 0.5 + r1.x;
	r1.y = i.texcoord.y;
	r1 = tex2D(InterlaceMapSampler, r1.xy);
	r1.y = 1;
	r0.w = (-InterlaceTotalNum.x >= 0) ? r1.y : r1.w;
	r0.w = r0.w * i.color.w;
	r1.x = abs(MaskAlphaReverse.x);
	r0.w = (-r1.x >= 0) ? r0.w : 0;
	r0.xyz = (-r0.www >= 0) ? 0 : r0.xyz;
	r1.xyz = -r0.xyz + 1;
	r2 = i.color.xyz * 256 + -128;
	r1.xyz = r1.xyz * r2.xyz;
	r1.xyz = r1.xyz * 0.0078125;
	r1.w = r0.x * 0.0078125;
	r3 = r2.xyz * r1.www;
	r1.xyz = (-r2.xyz >= 0) ? r3.xyz : r1.xyz;
	r1.xyz = (-r0.www >= 0) ? 0 : r1.xyz;
	o.w = r0.w;
	o.xyz = r0.xyz + r1.xyz;

	return o;
}
