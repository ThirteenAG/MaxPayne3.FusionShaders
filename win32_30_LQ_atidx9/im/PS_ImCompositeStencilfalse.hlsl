float MaskAlphaReverse : register(c205);
sampler2D RenderMapPointSampler : register(s1);
sampler2D StencilCopySampler : register(s6);
float StencilTech : register(c207);

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
	r0 = tex2D(StencilCopySampler, i.texcoord.xy);
	r0.x = r0.w + -0.5015686;
	r0.y = (r0.x >= 0) ? -128 : -0;
	r0.y = r0.w * 255 + r0.y;
	r0.z = r0.y + -63.9;
	r0.z = (r0.z >= 0) ? -64 : -0;
	r0.y = r0.z + r0.y;
	r0.z = r0.y + -31.9;
	r0.z = (r0.z >= 0) ? -32 : -0;
	r0.y = r0.z + r0.y;
	r0.z = r0.y + -15.9;
	r0.z = (r0.z >= 0) ? -16 : -0;
	r0.y = r0.z + r0.y;
	r0.z = r0.y + -7.9;
	r0.z = (r0.z >= 0) ? -8 : -0;
	r0.y = r0.z + r0.y;
	r0.y = r0.y + -1;
	r0.y = -abs(r0.y) + 0.1;
	r0.y = (r0.y >= 0) ? 1 : 0;
	r0.z = (r0.x >= 0) ? r0.y : 0;
	r0.x = (r0.x >= 0) ? 0 : r0.y;
	r0.w = abs(StencilTech.x);
	r1.xy = r0.ww + float2(-1, -2);
	r0.y = (-abs(r1.y) >= 0) ? r0.z : r0.y;
	r0.x = (-abs(r1.x) >= 0) ? r0.x : r0.y;
	r0.y = -r0.x + 1;
	r0.xy = r0.xy * i.color.ww;
	r0.x = (StencilTech.x >= 0) ? r0.x : r0.y;
	r0.y = abs(MaskAlphaReverse.x);
	r0.x = (-r0.y >= 0) ? r0.x : 0;
	r1 = tex2D(RenderMapPointSampler, i.texcoord.xy);
	r0.yzw = -r1.xyz + 1;
	r2 = i.color.xyz * 256 + -128;
	r0.yzw = r0.yzw * r2.xyz;
	r0.yzw = r0.yzw * 0.0078125;
	r1.w = r1.x * 0.0078125;
	r1.xyz = (-r0.xxx >= 0) ? 0 : r1.xyz;
	r3 = r2.xyz * r1.www;
	r0.yzw = (-r2.xyz >= 0) ? r3.xyz : r0.yzw;
	r0.yzw = (-r0.xxx >= 0) ? 0 : r0.yzw;
	o.w = r0.x;
	o.xyz = r0.yzw + r1.xyz;

	return o;
}
