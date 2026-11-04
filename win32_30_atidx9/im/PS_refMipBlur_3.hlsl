sampler2D RefBlurMapSampler : register(s2);
float4 refMipBlurParams : register(c200);

struct PS_OUT
{
	float4 color : COLOR;
	float4 color1 : COLOR1;
};

PS_OUT main(float2 texcoord : TEXCOORD)
{
	PS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	r0.xy = -refMipBlurParams.zw + texcoord.xy;
	r0 = tex2D(RefBlurMapSampler, r0.xy);
	r1 = tex2D(RefBlurMapSampler, texcoord.xy);
	r0.xyz = r0.xyz + r1.xyz;
	r1.xy = float2(1, -1);
	r1 = refMipBlurParams.zwzw * r1.xyyx + texcoord.xyxy;
	r2 = tex2D(RefBlurMapSampler, r1.xy);
	r1 = tex2D(RefBlurMapSampler, r1.zw);
	r0.xyz = r0.xyz + r2.xyz;
	r0.xyz = r1.xyz + r0.xyz;
	r1.xy = refMipBlurParams.zw + texcoord.xy;
	r1 = tex2D(RefBlurMapSampler, r1.xy);
	r0.xyz = r0.xyz + r1.xyz;
	r0.xyz = r0.xyz * 0.2;
	o.color.xyz = r0.xyz;
	o.color1.xyz = r0.xyz;
	o.color.w = 1;
	o.color1.w = 1;

	return o;
}
