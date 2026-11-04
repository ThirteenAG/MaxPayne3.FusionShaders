sampler2D MLAAPointSampler : register(s0);
float4 g_vTexelSize : register(c88);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	r0 = tex2D(MLAAPointSampler, texcoord.xy);
	r1.xyz = float3(-1, 0, 1);
	r2 = g_vTexelSize.xyxy * r1.xyzy + texcoord.xyxy;
	r3 = tex2D(MLAAPointSampler, r2.xy);
	r2 = tex2D(MLAAPointSampler, r2.zw);
	r3.z = r2.x;
	r1 = g_vTexelSize.xyxy * r1.yxyz + texcoord.xyxy;
	r2 = tex2D(MLAAPointSampler, r1.xy);
	r1 = tex2D(MLAAPointSampler, r1.zw);
	r3.w = r1.x;
	r3.y = r2.x;
	r0 = r0.x + -r3;
	r0 = abs(r0) + -0.001;
	r0 = (r0 >= 0) ? 1 : 0;
	r1.x = dot(r0, r0);
	o = r0;
	r0 = (-r1.x >= 0) ? -1 : 1;
	clip(r0);

	return o;
}
