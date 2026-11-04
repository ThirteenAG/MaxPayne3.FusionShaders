sampler2D ConvertSampler : register(s0);
float4 gShadowParam18192021 : register(c51);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	r0 = tex2D(ConvertSampler, texcoord.xy);
	r1.xyz = float3(0, -1, 1);
	r1 = gShadowParam18192021.y * r1.xyxz + texcoord.xyxy;
	r2 = tex2D(ConvertSampler, r1.xy);
	r1 = tex2D(ConvertSampler, r1.zw);
	r0.xy = r0.xy + r2.xy;
	r0.xy = r1.xy + r0.xy;
	o.xy = r0.xy * 0.33333334;
	o.zw = 1;

	return o;
}
