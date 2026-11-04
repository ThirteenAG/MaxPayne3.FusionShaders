sampler2D gDeferredLightSampler1 : register(s1);
float g_fSSAOBilateralCoef : register(c122);
float4 globalScreenSize : register(c41);

float4 main(float2 vpos : VPOS) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	float3 r5;
	r0 = 0.51 + vpos.xyxy;
	r0 = r0 * globalScreenSize.zwzw;
	r0 = r0 + r0;
	r1.zw = globalScreenSize.zw;
	r2 = r1.zwzw * float4(-4, 0, -2, 0) + r0.zwzw;
	r3 = tex2D(gDeferredLightSampler1, r2.xy);
	r2 = tex2D(gDeferredLightSampler1, r2.zw);
	r4 = tex2D(gDeferredLightSampler1, r0.zw);
	r0 = r1.zwzw * float4(2, 0, 4, 0) + r0;
	r1.x = dot(r4.yz, float2(255, 1)) + 0;
	r1.y = dot(r3.yz, float2(255, 1)) + -r1.x;
	r1.z = 1 / g_fSSAOBilateralCoef.x;
	r1.y = r1.z * abs(r1.y);
	r1.y = r1.y * r1.y;
	r1.y = r1.y * -0.7213475;
	r1.y = exp2(r1.y);
	r5.z = r1.y * 0.5;
	r5.xy = r3.xw * r5.zz;
	r3.xyz = r4.xwx * float3(1, 1, 0) + float3(0, 0, 1);
	o.yz = r4.yz;
	r3.xyz = r5.xyz + r3.xyz;
	r1.y = dot(r2.yz, float2(255, 1)) + -r1.x;
	r1.y = r1.z * abs(r1.y);
	r1.y = r1.y * r1.y;
	r1.y = r1.y * -0.7213475;
	r1.y = exp2(r1.y);
	r4.z = r1.y * 0.75;
	r4.xy = r2.xw * r4.zz;
	r2.xyz = r3.xyz + r4.xyz;
	r3 = tex2D(gDeferredLightSampler1, r0.xy);
	r0 = tex2D(gDeferredLightSampler1, r0.zw);
	r1.y = dot(r3.yz, float2(255, 1)) + -r1.x;
	r0.y = dot(r0.yz, float2(255, 1)) + -r1.x;
	r0.y = r1.z * abs(r0.y);
	r0.z = r1.z * abs(r1.y);
	r0.yz = r0.yz * r0.yz;
	r0.yz = r0.yz * -0.7213475;
	r0.z = exp2(r0.z);
	r1.z = r0.z * 0.75;
	r0.y = exp2(r0.y);
	r4.z = r0.y * 0.5;
	r1.xy = r1.zz * r3.xw;
	r1.xyz = r1.xyz + r2.xyz;
	r4.xy = r0.xw * r4.zz;
	r0.xyz = r4.xyz + r1.xyz;
	r0.z = 1 / r0.z;
	o.xw = r0.zz * r0.xy;

	return o;
}
