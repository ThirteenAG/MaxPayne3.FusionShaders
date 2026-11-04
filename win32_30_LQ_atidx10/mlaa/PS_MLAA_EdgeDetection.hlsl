sampler2D MLAAPointSampler : register(s0);
float4 g_vRelativeLuminanceThresholdParams : register(c90);
float4 g_vTexelSize : register(c88);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float2 r4;
	float4 r5;
	float4 r6;
	r0.xyz = float3(-1, 0, 1);
	r1 = g_vTexelSize.xyxy * r0.xyzy + texcoord.xyxy;
	r2 = tex2D(MLAAPointSampler, r1.xy);
	r1 = tex2D(MLAAPointSampler, r1.zw);
	r0.w = max(r2.x, r2.y);
	r1.w = max(r0.w, r2.z);
	r2.x = dot(r2.xyz, float3(0.2126, 0.7152, 0.0722));
	r0.w = r1.w * g_vRelativeLuminanceThresholdParams.y;
	r1.w = max(g_vRelativeLuminanceThresholdParams.x, r0.w);
	r3 = tex2D(MLAAPointSampler, texcoord.xy);
	r0.w = max(r3.x, r3.y);
	r4.x = max(r0.w, r3.z);
	r0.w = dot(r3.xyz, float3(0.2126, 0.7152, 0.0722));
	r3.x = r4.x * g_vRelativeLuminanceThresholdParams.y;
	r4.x = max(g_vRelativeLuminanceThresholdParams.x, r3.x);
	r3.x = min(r1.w, r4.x);
	r5 = g_vTexelSize.xyxy * r0.yxyz + texcoord.xyxy;
	r6 = tex2D(MLAAPointSampler, r5.xy);
	r5 = tex2D(MLAAPointSampler, r5.zw);
	r0.x = max(r6.x, r6.y);
	r1.w = max(r0.x, r6.z);
	r2.y = dot(r6.xyz, float3(0.2126, 0.7152, 0.0722));
	r0.x = r1.w * g_vRelativeLuminanceThresholdParams.y;
	r1.w = max(g_vRelativeLuminanceThresholdParams.x, r0.x);
	r3.y = min(r1.w, r4.x);
	r0.x = max(r1.x, r1.y);
	r4.y = max(r0.x, r1.z);
	r2.z = dot(r1.xyz, float3(0.2126, 0.7152, 0.0722));
	r0.x = r4.y * g_vRelativeLuminanceThresholdParams.y;
	r1.x = max(g_vRelativeLuminanceThresholdParams.x, r0.x);
	r3.z = min(r1.x, r4.x);
	r0.x = max(r5.x, r5.y);
	r1.x = max(r0.x, r5.z);
	r2.w = dot(r5.xyz, float3(0.2126, 0.7152, 0.0722));
	r0 = r0.w + -r2;
	r1.x = r1.x * g_vRelativeLuminanceThresholdParams.y;
	r2.x = max(g_vRelativeLuminanceThresholdParams.x, r1.x);
	r3.w = min(r2.x, r4.x);
	r0 = abs(r0) + -r3;
	r0 = (r0 >= 0) ? 1 : 0;
	r1.x = dot(r0, r0);
	o = r0;
	r0 = (-r1.x >= 0) ? -1 : 1;
	clip(r0);

	return o;
}
