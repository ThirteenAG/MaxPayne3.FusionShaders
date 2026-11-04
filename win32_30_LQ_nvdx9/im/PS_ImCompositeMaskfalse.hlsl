sampler2D AlphaMaskMapSampler : register(s3);
float MaskAlphaReverse : register(c205);
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
	r0 = tex2D(RenderMapPointSampler, i.texcoord.xy);
	r1.xyz = -r0.xyz + 1;
	r2.xyz = i.color.xyz * 256 + -128;
	r1.xyz = r1.xyz * r2.xyz;
	r1.xyz = r1.xyz * 0.0078125;
	r0.w = r0.x * 0.0078125;
	r3 = r2.xyz * r0.www;
	r1.xyz = (-r2.xyz >= 0) ? r3.xyz : r1.xyz;
	r0.w = abs(MaskAlphaReverse.x);
	r2 = tex2D(AlphaMaskMapSampler, i.texcoord1.xy);
	r1.w = -r2.w + 1;
	r2.x = r2.w * i.color.w;
	r1.w = r1.w * i.color.w;
	r0.w = (-r0.w >= 0) ? r2.x : r1.w;
	r1.xyz = (-r0.www >= 0) ? 0 : r1.xyz;
	r0.xyz = (-r0.www >= 0) ? 0 : r0.xyz;
	o.w = r0.w;
	o.xyz = r1.xyz + r0.xyz;

	return o;
}
