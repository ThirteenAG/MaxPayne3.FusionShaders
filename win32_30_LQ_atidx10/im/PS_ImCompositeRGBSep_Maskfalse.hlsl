sampler2D AlphaMaskMapSampler : register(s3);
float2 BlueOff : register(c212);
float2 GreenOff : register(c211);
float MaskAlphaReverse : register(c205);
float2 RedOff : register(c210);
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
	r0.w = abs(MaskAlphaReverse.x);
	r1 = tex2D(AlphaMaskMapSampler, i.texcoord1.xy);
	r1.x = -r1.w + 1;
	r1.xy = r1.xw * i.color.ww;
	r0.w = (-r0.w >= 0) ? r1.y : r1.x;
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
