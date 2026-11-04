sampler2D DiffuseTexSampler : register(s0);
sampler2D FrameMapTexSampler : register(s1);
float gBlurAmount : register(c105);
float2 gHeatHazeRippleLength : register(c111);
float2 gHeatHazeRippleRate : register(c110);
float gRefraction : register(c106);
float4 globalScreenSize : register(c41);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord3 : TEXCOORD3;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	r0.x = 1 / i.texcoord3.z;
	r0.y = i.texcoord3.x * r0.x + i.texcoord3.w;
	r0.y = r0.y * gHeatHazeRippleRate.x;
	r0.y = r0.y * 1.5915494 + 0.5;
	r0.y = frac(r0.y);
	r0.y = r0.y * 6.2831855 + -3.1415927;
	r1.y = sin(r0.y);
	r0.y = r1.y * gHeatHazeRippleLength.x;
	r0.zw = i.texcoord3.xy * r0.xx + 1;
	r0.x = i.texcoord3.y * -r0.x + i.texcoord3.w;
	r0.x = r0.x * gHeatHazeRippleRate.y;
	r0.x = r0.x * 1.5915494 + 0.5;
	r0.x = frac(r0.x);
	r0.x = r0.x * 6.2831855 + -3.1415927;
	r1.x = cos(r0.x);
	r0.x = r1.x * gHeatHazeRippleLength.y;
	r0.xy = r0.xy * globalScreenSize.wz;
	r0.z = r0.z * 0.5;
	r0.w = r0.w * -0.5 + 1;
	r1.y = r0.x * gRefraction.x + r0.w;
	r1.x = r0.y * gRefraction.x + r0.z;
	r0 = tex2D(FrameMapTexSampler, r1.xy);
	r2.x = gBlurAmount.x;
	r3 = r2.x * float4(-0.00326212, -0.0040581, -0.00695914, 0.00457137) + r1.xyxy;
	r4 = tex2D(FrameMapTexSampler, r3.xy);
	r3 = tex2D(FrameMapTexSampler, r3.zw);
	r0.xyz = r0.xyz + r4.xyz;
	r0.xyz = r3.xyz + r0.xyz;
	r3 = r2.x * float4(-0.00203345, 0.00620716, 0.0096234, -0.00194983) + r1.xyxy;
	r4 = tex2D(FrameMapTexSampler, r3.xy);
	r3 = tex2D(FrameMapTexSampler, r3.zw);
	r0.xyz = r0.xyz + r4.xyz;
	r0.xyz = r3.xyz + r0.xyz;
	r3 = r2.x * float4(0.00519456, 0.00767022, 0.00185461, -0.00893124) + r1.xyxy;
	r1 = r2.x * float4(0.0089642, 0.00412458, -0.00791559, -0.0059771) + r1.xyxy;
	r2 = tex2D(FrameMapTexSampler, r3.xy);
	r3 = tex2D(FrameMapTexSampler, r3.zw);
	r0.xyz = r0.xyz + r2.xyz;
	r0.xyz = r3.xyz + r0.xyz;
	r2 = tex2D(FrameMapTexSampler, r1.xy);
	r1 = tex2D(FrameMapTexSampler, r1.zw);
	r0.xyz = r0.xyz + r2.xyz;
	r0.xyz = r1.xyz + r0.xyz;
	r0.xyz = r0.xyz * i.texcoord.xyz;
	r0.xyz = r0.xyz * 0.125;
	r1 = tex2D(DiffuseTexSampler, i.texcoord1.xy);
	r2 = tex2D(DiffuseTexSampler, i.texcoord1.zw);
	r3.x = lerp(r1.w, r2.w, 0.5);
	r0.w = saturate(r3.x * i.texcoord.w);
	o = max(r0, 0);

	return o;
}
