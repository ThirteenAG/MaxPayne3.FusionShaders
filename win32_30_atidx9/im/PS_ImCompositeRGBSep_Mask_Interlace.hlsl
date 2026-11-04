sampler2D AlphaMaskMapSampler : register(s3);
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
	float2 texcoord1 : TEXCOORD1;
	float4 color : COLOR;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float3 r3;
	r0.x = 1 / InterlaceTotalNum.x;
	r0.y = r0.x * InterlaceIndex.x;
	r0.x = r0.x * 0.5 + r0.y;
	r0.y = i.texcoord.y;
	r0 = tex2D(InterlaceMapSampler, r0.xy);
	r0.y = 1;
	r0.x = (-InterlaceTotalNum.x >= 0) ? r0.y : r0.w;
	r1 = tex2D(AlphaMaskMapSampler, i.texcoord1.xy);
	r0.y = -r1.w + 1;
	r0.z = r1.w * i.color.w;
	r0.z = r0.x * r0.z;
	r0.y = r0.y * i.color.w;
	r0.x = r0.x * r0.y;
	r0.y = abs(MaskAlphaReverse.x);
	r0.x = (-r0.y >= 0) ? r0.z : r0.x;
	r0.yz = RedOff.xy + i.texcoord.xy;
	r1 = tex2D(RenderMapPointSampler, r0.yz);
	r0.yz = GreenOff.xy + i.texcoord.xy;
	r2 = tex2D(RenderMapPointSampler, r0.yz);
	r1.y = r2.y;
	r0.yz = BlueOff.xy + i.texcoord.xy;
	r2 = tex2D(RenderMapPointSampler, r0.yz);
	r1.z = r2.z;
	r0.yzw = (-r0.xxx >= 0) ? 0 : r1.xyz;
	r1.xyz = -r0.yzw + 1;
	r2.xyz = i.color.xyz * 256 + -128;
	r1.xyz = r1.xyz * r2.xyz;
	r1.xyz = r1.xyz * 0.0078125;
	r1.w = r0.y * 0.0078125;
	r3 = r2.xyz * r1.www;
	r1.xyz = (-r2.xyz >= 0) ? r3.xyz : r1.xyz;
	r1.xyz = (-r0.xxx >= 0) ? 0 : r1.xyz;
	o.w = r0.x;
	o.xyz = r0.yzw + r1.xyz;

	return o;
}
