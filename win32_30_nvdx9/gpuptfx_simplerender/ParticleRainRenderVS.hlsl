float4 gColorTint : register(c92);
float4 gColorTintPhase2 : register(c93);
float gMotionBlur : register(c88);
float4 gRadius : register(c89);
float4 gTextureAnimation : register(c91);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorldViewProj : register(c8);

struct VS_IN
{
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float3 r3;
	r0.x = 100 * i.texcoord.x;
	r0.y = frac(r0.x);
	r0.z = r0.x + -r0.y;
	r0.x = (r0.x < -r0.x) ? 1 : 0;
	r0.y = (-r0.y < r0.y) ? 1 : 0;
	r0.x = r0.x * r0.y + r0.z;
	r0.y = r0.x * 32;
	r0.y = (r0.y >= -r0.y) ? 1 : 0;
	r0.y = r0.y * 64 + -32;
	r0.z = 1 / r0.y;
	r0.x = r0.z * r0.x;
	r0.x = frac(r0.x);
	r0.x = r0.x * r0.y;
	r0.y = frac(r0.x);
	r0.z = r0.x + -r0.y;
	r0.x = (r0.x < -r0.x) ? 1 : 0;
	r0.y = (-r0.y < r0.y) ? 1 : 0;
	r0.x = r0.x * r0.y + r0.z;
	r0.x = r0.x * 0.03125;
	if (-abs(i.texcoord1.w) >= abs(i.texcoord1.w)) {
		r0.y = gRadius.y * r0.x + gRadius.x;
		r0.z = -0.5 + i.texcoord2.x;
		r1.xyz = normalize(i.texcoord1.xyz);
		r2.xyz = gViewInverse[3].yzx + -i.texcoord.yzx;
		r3 = r1.zxy * r2.xyz;
		r2.xyz = r1.yzx * r2.yzx + -r3.xyz;
		r3 = normalize(r2.xyz);
		r2.xyz = gMotionBlur.xxx * i.texcoord1.xyz;
		r1.xyz = r0.yyy * r1.xyz + r2.xyz;
		r2.xyz = r0.yyy * r3.xyz;
		r0.y = 0.7 + -i.texcoord2.y;
		r1.xyz = -r1.xyz * r0.yyy;
		r0.yzw = r0.zzz * r2.xyz + r1.xyz;
		r0.yzw = r0.yzw + i.texcoord.xyz;
		r1 = r0.z * gWorldViewProj[1];
		r1 = r0.y * gWorldViewProj[0] + r1;
		r1 = r0.w * gWorldViewProj[2] + r1;
		o.position = r1 + gWorldViewProj[3];
		o.color = gColorTint;
		r1.x = i.texcoord2.x;
	} else {
		r0.x = gRadius.w * r0.x + gRadius.z;
		r0.yz = -0.5 + i.texcoord2.xy;
		r2.xyz = normalize(gViewInverse[0].xyz);
		r2.xyz = r0.xxx * r2.xyz;
		r3 = normalize(-gViewInverse[1].xyz);
		r3 = r0.xxx * r3.xyz;
		r0.xzw = r0.zzz * r3.xyz;
		r0.xyz = r0.yyy * r2.xyz + r0.xzw;
		r0.xyz = r0.xyz + i.texcoord.xyz;
		r2 = r0.y * gWorldViewProj[1];
		r2 = r0.x * gWorldViewProj[0] + r2;
		r0 = r0.z * gWorldViewProj[2] + r2;
		o.position = r0 + gWorldViewProj[3];
		r0.x = i.texcoord.w * gTextureAnimation.x + -gTextureAnimation.y;
		r0.y = frac(r0.x);
		r0.z = r0.x + -r0.y;
		r0.x = (r0.x < -r0.x) ? 1 : 0;
		r0.y = (-r0.y < r0.y) ? 1 : 0;
		r0.x = r0.x * r0.y + r0.z;
		r0.x = saturate(r0.x * gTextureAnimation.z);
		r0.x = gTextureAnimation.z * i.texcoord2.x + r0.x;
		r1.x = r0.x + -10;
		o.color = gColorTintPhase2;
	}
	r1.y = i.texcoord2.y;
	o.texcoord = r1.xy;

	return o;
}
